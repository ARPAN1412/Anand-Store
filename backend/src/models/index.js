const User = require('./User');
const Category = require('./Category');
const MenuItem = require('./MenuItem');
const Order = require('./Order');
const OrderItem = require('./OrderItem');
const Reservation = require('./Reservation');

// Category - MenuItem
Category.hasMany(MenuItem, { foreignKey: 'categoryId', as: 'menuItems' });
MenuItem.belongsTo(Category, { foreignKey: 'categoryId', as: 'category' });

// User - Order
User.hasMany(Order, { foreignKey: 'userId', as: 'orders' });
Order.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// User - Reservation
User.hasMany(Reservation, { foreignKey: 'userId', as: 'reservations' });
Reservation.belongsTo(User, { foreignKey: 'userId', as: 'user' });

// Order - OrderItem
Order.hasMany(OrderItem, { foreignKey: 'orderId', as: 'items' });
OrderItem.belongsTo(Order, { foreignKey: 'orderId', as: 'order' });

// MenuItem - OrderItem
MenuItem.hasMany(OrderItem, { foreignKey: 'menuItemId', as: 'orderItems' });
OrderItem.belongsTo(MenuItem, { foreignKey: 'menuItemId', as: 'menuItem' });

module.exports = {
  User,
  Category,
  MenuItem,
  Order,
  OrderItem,
  Reservation
};
