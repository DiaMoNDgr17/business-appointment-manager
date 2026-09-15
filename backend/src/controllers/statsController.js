const db = require('../config/db');

exports.overview = async (req, res) => {
  try {
    const businessId = req.user.business_id;

    const [[appointments]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM appointments
       WHERE business_id = ?`,
      [businessId]
    );

    const [[clients]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM clients
       WHERE business_id = ?`,
      [businessId]
    );

    const [[scheduled]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM appointments
       WHERE business_id = ? AND status = 'scheduled'`,
      [businessId]
    );

    const [[completed]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM appointments
       WHERE business_id = ? AND status = 'completed'`,
      [businessId]
    );

    const [[cancelled]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM appointments
       WHERE business_id = ? AND status = 'cancelled'`,
      [businessId]
    );

    const [[today]] = await db.query(
      `SELECT COUNT(*) AS total
       FROM appointments
       WHERE business_id = ?
       AND appointment_date = CURDATE()
       AND status = 'scheduled'`,
      [businessId]
    );

    const [frequentClients] = await db.query(
      `SELECT
        c.id,
        c.full_name,
        c.phone,
        COUNT(a.id) AS appointment_count
       FROM clients c
       LEFT JOIN appointments a ON a.client_id = c.id
       WHERE c.business_id = ?
       GROUP BY c.id, c.full_name, c.phone
       ORDER BY appointment_count DESC, c.full_name ASC
       LIMIT 5`,
      [businessId]
    );

    res.json({
      totalAppointments: appointments.total,
      totalClients: clients.total,
      totalScheduled: scheduled.total,
      totalCompleted: completed.total,
      totalCancelled: cancelled.total,
      totalToday: today.total,
      frequentClients,
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};