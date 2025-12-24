const pool = require('../../../core/config/conn');

class MySQLUserRepository {
  async create(userRequest) {
    const [result] = await pool.query(
      'INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())',
      [userRequest.name, userRequest.email]
    );

    const [rows] = await pool.query(
      'SELECT * FROM users WHERE id = ?',
      [result.insertId]
    );

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      email: row.email,
      createdAt: new Date(row.created_at)
    };
  }

  async findAll() {
    const [rows] = await pool.query('SELECT * FROM users');

    return rows.map(row => ({
      id: row.id,
      name: row.name,
      email: row.email,
      createdAt: new Date(row.created_at)
    }));
  }

  async findById(id) {
    const [rows] = await pool.query(
      'SELECT * FROM users WHERE id = ?',
      [id]
    );

    if (rows.length === 0) return null;

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      email: row.email,
      createdAt: new Date(row.created_at)
    };
  }
}

module.exports = { MySQLUserRepository };