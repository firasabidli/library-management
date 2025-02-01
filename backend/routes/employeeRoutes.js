const express = require('express');
const router = express.Router();
const { addEmployee, getEmployees, paySalary } = require('../controllers/employeeController');

// Add Employee
router.post('/', addEmployee);

// Get All Employees
router.get('/', getEmployees);

// Pay Salary
router.put('/pay/:id', paySalary);

module.exports = router;
