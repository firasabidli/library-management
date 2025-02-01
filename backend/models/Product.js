const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, enum: ['Fournitures scolaires', 'Tabac'], required: true },
  price: { type: Number, required: true }, // The price of the product
  stock: { type: Number, default: 0 }, // Current stock quantity
  supplier: { type: String }, // Supplier name (optional for better tracking)
  description: { type: String }, // Optional description for additional details
  createdAt: { type: Date, default: Date.now }, // Timestamp for creation
});

module.exports = mongoose.model('Product', ProductSchema);
