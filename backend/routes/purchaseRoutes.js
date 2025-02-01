const express = require('express');
const router = express.Router();
const { addPurchase, getPurchases, deletePurchase, updatePurchase } = require('../controllers/purchaseController');

// Ajouter un achat
router.post('/', addPurchase);

// Obtenir tous les achats
router.get('/', getPurchases);

// Supprimer un achat
router.delete('/:id', deletePurchase);

// Mettre à jour un achat
router.put('/:id', updatePurchase);

module.exports = router;
