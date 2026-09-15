const express = require('express');

const router = express.Router();

const authMiddleware = require('../middlewares/authMiddleware');
const appointmentController = require('../controllers/appointmentController');

router.get(
  '/',
  authMiddleware,
  appointmentController.getAppointments
);

router.post(
  '/',
  authMiddleware,
  appointmentController.createAppointment
);

router.patch(
  '/:id/status',
  authMiddleware,
  appointmentController.updateAppointmentStatus
);

module.exports = router;