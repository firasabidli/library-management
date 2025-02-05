const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employeeController');

// Route pour ajouter un employé
router.post('/employees', employeeController.addEmployee);

// Route pour récupérer tous les employés
router.get('/employees', employeeController.getEmployees);

// Route pour modifier un employé
router.put('/employees/:id', employeeController.updateEmployee);

// Route pour payer le salaire d'un employé
router.post('/employees/:id/pay', employeeController.paySalary);

// Route pour supprimer un employé
router.delete('/employees/:id', employeeController.deleteEmployee);

module.exports = router;
