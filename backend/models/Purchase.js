const mongoose = require('mongoose');

const PurchaseSchema = new mongoose.Schema({
  itemName: { type: String, required: true },
  supplier: { type: String, required: true },
  quantity: { type: Number, required: true },
  totalPrice: { type: Number, required: true },
  date: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Purchase', PurchaseSchema);
