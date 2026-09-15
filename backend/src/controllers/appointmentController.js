const db = require('../config/db');

exports.getAppointments = async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT a.*, c.full_name AS client_name
       FROM appointments a
       JOIN clients c ON c.id = a.client_id
       WHERE a.business_id = ?
       ORDER BY a.appointment_date DESC, a.start_time DESC`,
      [req.user.business_id]
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.createAppointment = async (req, res) => {
  try {
    const {
      client_id,
      title,
      description,
      appointment_date,
      start_time,
      end_time,
    } = req.body;

    if (
      !client_id ||
      !title ||
      !appointment_date ||
      !start_time ||
      !end_time
    ) {
      return res.status(400).json({
        message: 'Συμπλήρωσε όλα τα υποχρεωτικά πεδία του ραντεβού.',
      });
    }

    const [clientRows] = await db.query(
      `SELECT id
       FROM clients
       WHERE id = ? AND business_id = ?`,
      [client_id, req.user.business_id]
    );

    if (clientRows.length === 0) {
      return res.status(404).json({
        message: 'Ο επιλεγμένος πελάτης δεν βρέθηκε.',
      });
    }

    const [result] = await db.query(
      `INSERT INTO appointments (
        business_id,
        client_id,
        user_id,
        title,
        description,
        appointment_date,
        start_time,
        end_time,
        status
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        req.user.business_id,
        client_id,
        req.user.id,
        title,
        description || null,
        appointment_date,
        start_time,
        end_time,
        'scheduled',
      ]
    );

    res.status(201).json({
      message: 'Appointment created',
      id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateAppointmentStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const allowedStatuses = ['scheduled', 'completed', 'cancelled'];

    if (!allowedStatuses.includes(status)) {
      return res.status(400).json({
        message:
          'Μη έγκυρη κατάσταση. Επιτρέπονται: scheduled, completed, cancelled.',
      });
    }

    const [result] = await db.query(
      `UPDATE appointments
       SET status = ?
       WHERE id = ? AND business_id = ?`,
      [status, id, req.user.business_id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Το ραντεβού δεν βρέθηκε.',
      });
    }

    res.json({
      message: 'Η κατάσταση του ραντεβού ενημερώθηκε επιτυχώς.',
      status,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};