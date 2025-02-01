const mongoose = require('mongoose');

const NeededProductSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
  requiredQuantity: { type: Number, required: true },
  currentStock: { type: Number, required: true },
  restockDate: { type: Date, default: Date.now },
  userNote: { type: String, default: '' }, // Added user note field
});

module.exports = mongoose.model('NeededProduct', NeededProductSchema);
