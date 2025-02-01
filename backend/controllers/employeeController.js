const Employee = require('../models/Employee');

// Add Employee
exports.addEmployee = async (req, res) => {
  const { name, position, salary } = req.body;

  try {
    const employee = new Employee({ name, position, salary });
    await employee.save();
    res.status(201).json({ message: 'Employé ajouté avec succès', employee });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Get All Employees
exports.getEmployees = async (req, res) => {
  try {
    const employees = await Employee.find();
    res.status(200).json(employees);
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};

// Pay Employee Salary
exports.paySalary = async (req, res) => {
  const { id } = req.params;
  const { amount } = req.body;

  try {
    const employee = await Employee.findById(id);
    if (!employee) {
      return res.status(404).json({ message: 'Employé non trouvé' });
    }

    // Update paid amount and pending amount
    employee.paidAmount += amount;
    employee.pendingAmount = employee.salary - employee.paidAmount;

    // Add payment to history
    employee.paymentHistory.push({ amount });

    await employee.save();
    res.status(200).json({ message: 'Salaire payé avec succès', employee });
  } catch (error) {
    res.status(500).json({ message: 'Erreur serveur', error: error.message });
  }
};
