const { Order, OrderItem, MenuItem, User } = require('../models');
const { v4: uuidv4 } = require('uuid');

// @desc    Create new order
// @route   POST /api/orders
// @access  Private
exports.createOrder = async (req, res) => {
  try {
    const {
      items,
      orderType,
      deliveryAddress,
      paymentMethod,
      specialInstructions
    } = req.body;

    console.log('=== Order Creation Debug ===');
    console.log('Items received:', JSON.stringify(items, null, 2));
    console.log('User ID:', req.user.id);

    // Validate items
    if (!items || items.length === 0) {
      return res.status(400).json({ 
        success: false,
        message: 'Order must contain at least one item' 
      });
    }

    // Calculate totals
    let subtotal = 0;
    const orderItems = [];
    
    for (const item of items) {
      console.log('Processing item:', item);
      
      // Ensure menuItemId is a string (UUID format)
      const menuItemId = String(item.menuItemId);
      
      console.log('Menu Item ID (converted):', menuItemId);
      
      // Validate UUID format
      const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
      if (!uuidRegex.test(menuItemId)) {
        console.error('Invalid UUID format:', menuItemId);
        return res.status(400).json({ 
          success: false,
          message: `Invalid menu item ID format: ${menuItemId}` 
        });
      }
      
      const menuItem = await MenuItem.findByPk(menuItemId);
      console.log('Found menu item:', menuItem ? menuItem.name : 'NOT FOUND');
      
      if (!menuItem) {
        return res.status(404).json({ 
          success: false,
          message: `Menu item with ID ${menuItemId} not found` 
        });
      }
      
      if (!menuItem.isAvailable) {
        return res.status(400).json({ 
          success: false,
          message: `${menuItem.name} is currently unavailable` 
        });
      }
      
      const itemSubtotal = parseFloat(menuItem.price) * item.quantity;
      subtotal += itemSubtotal;
      
      orderItems.push({
        menuItemId: menuItemId,
        menuItem: menuItem,
        quantity: item.quantity,
        price: menuItem.price,
        subtotal: itemSubtotal
      });
    }

    const tax = subtotal * 0.1; // 10% tax
    const deliveryFee = orderType === 'delivery' ? 5.00 : 0;
    const total = subtotal + tax + deliveryFee;

    // Generate order number
    const orderNumber = `ORD-${Date.now()}-${Math.floor(Math.random() * 1000)}`;

    // Create order
    const order = await Order.create({
      orderNumber,
      userId: req.user.id,
      status: 'pending',
      orderType,
      subtotal,
      tax,
      deliveryFee,
      total,
      paymentMethod,
      deliveryAddress,
      specialInstructions,
      estimatedDeliveryTime: new Date(Date.now() + 45 * 60000) // 45 minutes
    });

    // Create order items
    for (const orderItemData of orderItems) {
      await OrderItem.create({
        orderId: order.id,
        menuItemId: orderItemData.menuItemId,
        quantity: orderItemData.quantity,
        price: orderItemData.price,
        subtotal: orderItemData.subtotal
      });
    }

    // Fetch complete order with items
    const completeOrder = await Order.findByPk(order.id, {
      include: [
        {
          model: OrderItem,
          as: 'items',
          include: [{
            model: MenuItem,
            as: 'menuItem'
          }]
        }
      ]
    });

    res.status(201).json({
      success: true,
      data: completeOrder
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all orders (Admin)
// @route   GET /api/orders
// @access  Private/Admin
exports.getOrders = async (req, res) => {
  try {
    const { status } = req.query;
    
    let where = {};
    if (status) {
      where.status = status;
    }

    const orders = await Order.findAll({
      where,
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'name', 'email', 'phone']
        },
        {
          model: OrderItem,
          as: 'items',
          include: [{
            model: MenuItem,
            as: 'menuItem'
          }]
        }
      ],
      order: [['created_at', 'DESC']]
    });

    res.json({
      success: true,
      data: orders
    });
  } catch (error) {
    console.error('Error fetching orders:', error);
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user orders
// @route   GET /api/orders/my-orders
// @access  Private
exports.getMyOrders = async (req, res) => {
  try {
    const orders = await Order.findAll({
      where: { userId: req.user.id },
      include: [{
        model: OrderItem,
        as: 'items',
        include: [{
          model: MenuItem,
          as: 'menuItem'
        }]
      }],
      order: [['createdAt', 'DESC']]
    });

    res.json({
      success: true,
      data: orders
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update order status (Admin)
// @route   PUT /api/orders/:id/status
// @access  Private/Admin
exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    
    const order = await Order.findByPk(req.params.id);
    
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    await order.update({ status });

    res.json({
      success: true,
      data: order
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get order statistics (Admin)
// @route   GET /api/orders/stats
// @access  Private/Admin
exports.getOrderStats = async (req, res) => {
  try {
    const confirmed = await Order.count({ where: { status: 'confirmed' } });
    const cooking = await Order.count({ where: { status: 'cooking' } });
    const ready = await Order.count({ where: { status: 'ready' } });
    const outForDelivery = await Order.count({ where: { status: 'out_for_delivery' } });
    const delivered = await Order.count({ where: { status: 'delivered' } });
    const total = await Order.count();

    res.json({
      success: true,
      data: {
        confirmed,
        cooking,
        ready,
        outForDelivery,
        delivered,
        total
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
