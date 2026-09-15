const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../config/db');

exports.register = async (req, res) => {
  try {
    const { business_name, owner_name, full_name, email, password } = req.body;
    const hash = await bcrypt.hash(password, 10);

    const [businessResult] = await db.query(
      'INSERT INTO businesses (name, owner_name) VALUES (?, ?)',
      [business_name, owner_name]
    );

    const [userResult] = await db.query(
      'INSERT INTO users (business_id, full_name, email, password_hash, role) VALUES (?, ?, ?, ?, ?)',
      [businessResult.insertId, full_name, email, hash, 'owner']
    );

    res.status(201).json({
      message: 'Registered successfully',
      businessId: businessResult.insertId,
      userId: userResult.insertId
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const [rows] = await db.query('SELECT * FROM users WHERE email = ?', [email]);

    if (!rows.length) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: user.id, business_id: user.business_id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    res.json({ token, user });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};