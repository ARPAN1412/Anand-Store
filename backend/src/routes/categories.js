const express = require('express');
const router = express.Router();
const {
  getCategories,
  createCategory,
  updateCategory
} = require('../controllers/categoryController');
const { protect, authorize } = require('../middleware/auth');

router.get('/', getCategories);
router.post('/', protect, authorize('admin'), createCategory);
router.put('/:id', protect, authorize('admin'), updateCategory);

module.exports = router;
