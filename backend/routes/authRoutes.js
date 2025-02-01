const express = require('express');
const { body } = require('express-validator');
const { signup, login } = require('../controllers/authController');

const router = express.Router();

// Route Sign Up
router.post(
  '/signup',
  [
    body('name', 'Le nom est requis.').notEmpty(),
    body('email', 'Veuillez fournir un email valide.').isEmail(),
    body('password', 'Le mot de passe doit comporter au moins 6 caractères.').isLength({ min: 6 }),
  ],
  signup
);

// Route Login
router.post('/login', login);

module.exports = router;
