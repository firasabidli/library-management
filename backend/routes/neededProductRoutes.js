const express = require('express');
const router = express.Router();

// Ensure that the correct controller functions are imported
const { generateNeededProductsList, generateNeededProductPDF } = require('../controllers/neededProductController');

// Define the routes with correct callback functions
router.get('/', generateNeededProductsList);   // For listing needed products
router.get('/pdf', generateNeededProductPDF);  // For generating PDF report

module.exports = router;
