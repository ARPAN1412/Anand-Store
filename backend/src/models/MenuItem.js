const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const MenuItem = sequelize.define('MenuItem', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT
  },
  price: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false
  },
  categoryId: {
    type: DataTypes.UUID,
    field: 'category_id',
    allowNull: true
  },
  discountPrice: {
    type: DataTypes.DECIMAL(10, 2)
  },
  image: {
    type: DataTypes.STRING
  },
  rating: {
    type: DataTypes.DECIMAL(2, 1),
    defaultValue: 0.0
  },
  reviews: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  isVegetarian: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  isAvailable: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  preparationTime: {
    type: DataTypes.INTEGER,
    comment: 'in minutes'
  },
  tags: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  badge: {
    type: DataTypes.STRING
  },
  discount: {
    type: DataTypes.INTEGER
  }
}, {
  tableName: 'menu_items',
  underscored: true
});

module.exports = MenuItem;
