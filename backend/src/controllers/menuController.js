const { MenuItem, Category } = require('../models');
const { Op } = require('sequelize');

// @desc    Get all menu items
// @route   GET /api/menu
// @access  Public
exports.getMenuItems = async (req, res) => {
  try {
    const { category, search } = req.query;
    
    let where = {};
    
    if (category) {
      where.categoryId = category;
    }
    
    if (search) {
      where.name = { [Op.iLike]: `%${search}%` };
    }

    const menuItems = await MenuItem.findAll({
      where,
      include: [{
        model: Category,
        as: 'category',
        attributes: ['id', 'name']
      }],
      order: [['created_at', 'DESC']]
    });

    res.json({
      success: true,
      data: menuItems
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get single menu item
// @route   GET /api/menu/:id
// @access  Public
exports.getMenuItem = async (req, res) => {
  try {
    const menuItem = await MenuItem.findByPk(req.params.id, {
      include: [{
        model: Category,
        as: 'category'
      }]
    });

    if (!menuItem) {
      return res.status(404).json({ message: 'Menu item not found' });
    }

    res.json({
      success: true,
      data: menuItem
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Create menu item (Admin)
// @route   POST /api/menu
// @access  Private/Admin
exports.createMenuItem = async (req, res) => {
  try {
    const menuItem = await MenuItem.create(req.body);

    res.status(201).json({
      success: true,
      data: menuItem
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update menu item (Admin)
// @route   PUT /api/menu/:id
// @access  Private/Admin
exports.updateMenuItem = async (req, res) => {
  try {
    const menuItem = await MenuItem.findByPk(req.params.id);

    if (!menuItem) {
      return res.status(404).json({ message: 'Menu item not found' });
    }

    await menuItem.update(req.body);

    res.json({
      success: true,
      data: menuItem
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Delete menu item (Admin)
// @route   DELETE /api/menu/:id
// @access  Private/Admin
exports.deleteMenuItem = async (req, res) => {
  try {
    const menuItem = await MenuItem.findByPk(req.params.id);

    if (!menuItem) {
      return res.status(404).json({ message: 'Menu item not found' });
    }

    await menuItem.destroy();

    res.json({
      success: true,
      message: 'Menu item deleted'
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
