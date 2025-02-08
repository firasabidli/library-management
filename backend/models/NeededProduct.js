const mongoose = require('mongoose');

const NeededProductSchema = new mongoose.Schema({
  title: { type: String, required: true }, // Nom du produit
  requiredQuantity: { type: Number, required: true },
  currentStock: { type: Number, required: true },
  restockDate: { type: Date, default: Date.now },
  userNote: {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, // Référence à l'utilisateur
    note: { type: String, default: '' }, // Contenu de la note
  },
  status: { type: Number, default: 0 }, // 0 = en attente, 1 = validé
});

module.exports = mongoose.model('NeededProduct', NeededProductSchema);
