const { Reservation, User } = require('../models');

// @desc    Create reservation
// @route   POST /api/reservations
// @access  Private
exports.createReservation = async (req, res) => {
  try {
    const { date, time, partySize, specialRequests } = req.body;

    const reservation = await Reservation.create({
      userId: req.user.id,
      date,
      time,
      partySize,
      specialRequests,
      status: 'pending'
    });

    res.status(201).json({
      success: true,
      data: reservation
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get all reservations (Admin)
// @route   GET /api/reservations
// @access  Private/Admin
exports.getReservations = async (req, res) => {
  try {
    const reservations = await Reservation.findAll({
      include: [{
        model: User,
        as: 'user',
        attributes: ['id', 'name', 'email', 'phone']
      }],
      order: [['date', 'DESC'], ['time', 'DESC']]
    });

    res.json({
      success: true,
      data: reservations
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Get user reservations
// @route   GET /api/reservations/my-reservations
// @access  Private
exports.getMyReservations = async (req, res) => {
  try {
    const reservations = await Reservation.findAll({
      where: { userId: req.user.id },
      order: [['date', 'DESC'], ['time', 'DESC']]
    });

    res.json({
      success: true,
      data: reservations
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// @desc    Update reservation status (Admin)
// @route   PUT /api/reservations/:id
// @access  Private/Admin
exports.updateReservation = async (req, res) => {
  try {
    const reservation = await Reservation.findByPk(req.params.id);

    if (!reservation) {
      return res.status(404).json({ message: 'Reservation not found' });
    }

    await reservation.update(req.body);

    res.json({
      success: true,
      data: reservation
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
