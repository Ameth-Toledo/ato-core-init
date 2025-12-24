import { User } from '../models/User';
import pool from '../core/config/conn';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

export class UserRepository {
  async create(name: string, email: string): Promise<User> {
    const [result] = await pool.query<ResultSetHeader>(
      'INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())',
      [name, email]
    );

    const [rows] = await pool.query<RowDataPacket[]>(
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

  async findAll(): Promise<User[]> {
    const [rows] = await pool.query<RowDataPacket[]>('SELECT * FROM users');

    return rows.map(row => ({
      id: row.id,
      name: row.name,
      email: row.email,
      createdAt: new Date(row.created_at)
    }));
  }

  async findById(id: number): Promise<User | null> {
    const [rows] = await pool.query<RowDataPacket[]>(
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

  async update(id: number, name: string, email: string): Promise<User | null> {
    await pool.query(
      'UPDATE users SET name = ?, email = ? WHERE id = ?',
      [name, email, id]
    );

    return this.findById(id);
  }

  async delete(id: number): Promise<boolean> {
    const [result] = await pool.query<ResultSetHeader>(
      'DELETE FROM users WHERE id = ?',
      [id]
    );

    return result.affectedRows > 0;
  }
}