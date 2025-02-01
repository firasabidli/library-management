const Expense = require('../models/Expense');

// Add Expense
exports.addExpense = async (req, res) => {
  const { description, amount, category } = req.body;

  try {
    const expense = new Expense({ description, amount, category });
    await expense.save();
    res.status(201).json({ message: 'Dépense ajoutée avec succès', expense });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Get All Expenses
exports.getExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find();
    res.status(200).json(expenses);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Edit Expense
exports.editExpense = async (req, res) => {
    const { id } = req.params;
    const { description, amount, category } = req.body;
  
    try {
      const expense = await Expense.findById(id);
      if (!expense) {
        return res.status(404).json({ message: 'Dépense non trouvée' });
      }
  
      // Update fields
      expense.description = description || expense.description;
      expense.amount = amount || expense.amount;
      expense.category = category || expense.category;
  
      await expense.save();
  
      res.status(200).json({ message: 'Dépense modifiée avec succès', expense });
    } catch (error) {
      res.status(500).json({ message: 'Erreur serveur', error: error.message });
    }
  };
  

// Delete Expense
exports.deleteExpense = async (req, res) => {
  const { id } = req.params;

  try {
    const expense = await Expense.findById(id);
    if (!expense) {
      return res.status(404).json({ message: 'Dépense non trouvée' });
    }
    await expense.deleteOne();
    res.status(200).json({ message: 'Dépense supprimée avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
