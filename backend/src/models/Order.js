const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Order = sequelize.define('Order', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  },
  orderNumber: {
    type: DataTypes.STRING,
    unique: true,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM(
      'pending',
      'confirmed',
      'cooking',
      'ready',
      'out_for_delivery',
      'delivered',
      'cancelled'
    ),
    defaultValue: 'pending'
  },
  orderType: {
    type: DataTypes.ENUM('delivery', 'pickup', 'dine-in'),
    allowNull: false,
    defaultValue: 'delivery'
  },
  subtotal: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  tax: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0
  },
  deliveryFee: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0
  },
  discount: {
    type: DataTypes.DECIMAL(10, 2),
    defaultValue: 0
  },
  total: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  paymentMethod: {
    type: DataTypes.ENUM('card', 'cash', 'wallet'),
    allowNull: false
  },
  paymentStatus: {
    type: DataTypes.ENUM('pending', 'paid', 'failed'),
    defaultValue: 'pending'
  },
  deliveryAddress: {
    type: DataTypes.JSONB
  },
  specialInstructions: {
    type: DataTypes.TEXT
  },
  estimatedDeliveryTime: {
    type: DataTypes.DATE
  }
}, {
  tableName: 'orders',
  underscored: true
});

module.exports = Order;
