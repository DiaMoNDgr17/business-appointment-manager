const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const clientRoutes = require('./routes/clientRoutes');
const appointmentRoutes = require('./routes/appointmentRoutes');
const statsRoutes = require('./routes/statsRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Business Appointment Manager API running' });
});

app.use('/api/auth', authRoutes);
app.use('/api/clients', clientRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/stats', statsRoutes);

module.exports = app;