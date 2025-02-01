const mongoose = require('mongoose');

const EmployeeSchema = new mongoose.Schema({
  name: { type: String, required: true },
  position: { type: String, required: true },
  salary: { type: Number, required: true },
  paidAmount: { type: Number, default: 0 }, // Track how much has been paid
  pendingAmount: { type: Number, default: function() { return this.salary - this.paidAmount; } }, // Calculate pending salary
  paymentHistory: [{
    date: { type: Date, default: Date.now },
    amount: { type: Number, required: true },
  }],
});

module.exports = mongoose.model('Employee', EmployeeSchema);
