const express = require('express');
const { addProduct, getProducts, updateProduct, deleteProduct } = require('../controllers/productControllers');

const router = express.Router();

// Routes
router.post('/', addProduct);
router.get('/', getProducts);
router.put('/:id', updateProduct);
router.delete('/:id', deleteProduct);

module.exports = router;
