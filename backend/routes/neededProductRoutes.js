const express = require('express');
const router = express.Router();
const neededProductController = require('../controllers/neededProductController');

// Routes CRUD
router.post('/', neededProductController.addNeededProduct);
router.get('/', neededProductController.getNeededProducts);
router.put('/:id', neededProductController.updateNeededProduct);
router.put('/state/:id', neededProductController.updateNeededProductState);
router.delete('/:id', neededProductController.deleteNeededProduct);

// Route pour générer le PDF
router.get('/generate-pdf', neededProductController.generateNeededProductPDF);

module.exports = router;
