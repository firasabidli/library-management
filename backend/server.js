const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();

const connectDB = require('./config/db');
const productRoutes = require('./routes/productRoutes');
const purchaseRoutes = require('./routes/purchaseRoutes');
const expenseRoutes = require('./routes/expenseRoutes');
const employeeRoutes = require('./routes/employeeRoutes');
const neededProductRoutes = require('./routes/neededProductRoutes');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(
  cors({
    origin: ['http://localhost:5000', 'http://localhost:5555'], // Ajouter le port exact de l'application Flutter
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
  })
);

app.use(bodyParser.json());

// Connect to MongoDB
connectDB();

// Routes
app.use('/api/products', productRoutes);
app.use('/api/purchases', purchaseRoutes);
app.use('/api/expenses', expenseRoutes);
app.use('/api', employeeRoutes);
app.use('/api/needed-products', neededProductRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
// Default Route
app.get('/', (req, res) => {
  res.send('API is running...');
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
