// server.js or app.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config(); // Import dotenv at the very top

const app = express();

// Import routes
const reportRoutes = require('./routes/report_routes'); // Adjust path as needed

// Use body-parser middleware
app.use(bodyParser.json());

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// Use the routes
app.use('/api', reportRoutes);  // Assuming your routes are under the "/api" prefix

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
