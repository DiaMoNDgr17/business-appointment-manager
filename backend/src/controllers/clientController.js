const db = require('../config/db');

exports.getClients = async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT *
       FROM clients
       WHERE business_id = ?
       ORDER BY id DESC`,
      [req.user.business_id]
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

exports.createClient = async (req, res) => {
  try {
    const {
      full_name,
      phone,
      email,
      notes,
    } = req.body;

    if (!full_name || full_name.trim() === '') {
      return res.status(400).json({
        message: 'Το ονοματεπώνυμο είναι υποχρεωτικό.',
      });
    }

    const [result] = await db.query(
      `INSERT INTO clients (
        business_id,
        full_name,
        phone,
        email,
        notes
      ) VALUES (?, ?, ?, ?, ?)`,
      [
        req.user.business_id,
        full_name.trim(),
        phone || null,
        email || null,
        notes || null,
      ]
    );

    res.status(201).json({
      message: 'Client created',
      id: result.insertId,
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};

exports.updateClient = async (req, res) => {
  try {
    const { id } = req.params;

    const {
      full_name,
      phone,
      email,
      notes,
    } = req.body;

    if (!full_name || full_name.trim() === '') {
      return res.status(400).json({
        message: 'Το ονοματεπώνυμο είναι υποχρεωτικό.',
      });
    }

    const [result] = await db.query(
      `UPDATE clients
       SET
         full_name = ?,
         phone = ?,
         email = ?,
         notes = ?
       WHERE id = ? AND business_id = ?`,
      [
        full_name.trim(),
        phone || null,
        email || null,
        notes || null,
        id,
        req.user.business_id,
      ]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        message: 'Ο πελάτης δεν βρέθηκε.',
      });
    }

    res.json({
      message: 'Τα στοιχεία του πελάτη ενημερώθηκαν επιτυχώς.',
    });
  } catch (error) {
    res.status(500).json({
      message: error.message,
    });
  }
};