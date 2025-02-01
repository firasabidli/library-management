const express = require('express');
const router = express.Router();
const { addExpense, getExpenses, editExpense, deleteExpense } = require('../controllers/expenseController');

// Add Expense
router.post('/', addExpense);

// Get All Expenses
router.get('/', getExpenses);

// Edit Expense
router.put('/:id', editExpense);

// Delete Expense
router.delete('/:id', deleteExpense);

module.exports = router;
