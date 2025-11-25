const express = require('express');
const router = express.Router();
const {
  createOrder,
  getOrders,
  getMyOrders,
  updateOrderStatus,
  getOrderStats
} = require('../controllers/orderController');
const { protect, authorize } = require('../middleware/auth');

router.post('/', protect, createOrder);
router.get('/', protect, authorize('admin'), getOrders);
router.get('/my-orders', protect, getMyOrders);
router.get('/stats', protect, authorize('admin'), getOrderStats);
router.put('/:id/status', protect, authorize('admin'), updateOrderStatus);

module.exports = router;
