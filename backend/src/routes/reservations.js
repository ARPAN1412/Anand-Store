const express = require('express');
const router = express.Router();
const {
  createReservation,
  getReservations,
  getMyReservations,
  updateReservation
} = require('../controllers/reservationController');
const { protect, authorize } = require('../middleware/auth');

router.post('/', protect, createReservation);
router.get('/', protect, authorize('admin'), getReservations);
router.get('/my-reservations', protect, getMyReservations);
router.put('/:id', protect, authorize('admin'), updateReservation);

module.exports = router;
