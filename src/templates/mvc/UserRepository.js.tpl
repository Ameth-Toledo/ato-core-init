const pool = require('../core/config/conn');

class UserRepository {
  async create(name, email) {
    const [result] = await pool.query(
      'INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())',
      [name, email]
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

  async update(id, name, email) {
    await pool.query(
      'UPDATE users SET name = ?, email = ? WHERE id = ?',
      [name, email, id]
    );

    return this.findById(id);
  }

  async delete(id) {
    const [result] = await pool.query(
      'DELETE FROM users WHERE id = ?',
      [id]
    );

    return result.affectedRows > 0;
  }
}

module.exports = { UserRepository };