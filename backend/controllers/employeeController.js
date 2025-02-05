const Employee = require('../models/Employee');

// Ajouter un employé
exports.addEmployee = async (req, res) => {
  const { name, position, salary } = req.body;

  try {
    if (!name || !position || !salary || salary <= 0) {
      return res.status(400).json({ message: 'Données invalides' });
    }

    const employee = new Employee({ name, position, salary });
    await employee.save();
    res.status(201).json({ message: 'Employé ajouté avec succès', employee });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Récupérer tous les employés
exports.getEmployees = async (req, res) => {
  try {
    const employees = await Employee.find();
    res.status(200).json(employees);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Modifier les informations d’un employé
exports.updateEmployee = async (req, res) => {
  const { id } = req.params;
  const { name, position, salary } = req.body;

  try {
    if (!name || !position || !salary || salary <= 0) {
      return res.status(400).json({ message: 'Données invalides' });
    }

    const employee = await Employee.findById(id);
    if (!employee) {
      return res.status(404).json({ message: 'Employé non trouvé' });
    }

    // Mise à jour des informations
    employee.name = name;
    employee.position = position;
    employee.salary = salary;

    // Mise à jour du salaire restant
    employee.pendingAmount = employee.salary - employee.paidAmount;

    await employee.save();
    res.status(200).json({ message: 'Employé mis à jour avec succès', employee });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Payer le salaire d'un employé
exports.paySalary = async (req, res) => {
  const { id } = req.params;
  const { amount } = req.body;

  try {
    if (!amount || amount <= 0) {
      return res.status(400).json({ message: 'Montant invalide' });
    }

    const employee = await Employee.findById(id);
    if (!employee) {
      return res.status(404).json({ message: 'Employé non trouvé' });
    }

    if (amount > employee.pendingAmount) {
      return res.status(400).json({ message: 'Le montant dépasse le salaire restant' });
    }

    // Mise à jour du paiement
    employee.paidAmount += amount;
    employee.pendingAmount = employee.salary - employee.paidAmount;

    // Ajout à l'historique des paiements
    employee.paymentHistory.push({ amount });

    await employee.save();
    res.status(200).json({ message: 'Salaire payé avec succès', employee });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Delete Employee
exports.deleteEmployee = async (req, res) => {
  const { id } = req.params;

  try {
    const employee = await Employee.findByIdAndDelete(id);
    if (!employee) {
      return res.status(404).json({ message: 'Employé non trouvé' });
    }

    res.status(200).json({ message: 'Employé supprimé avec succès' });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
