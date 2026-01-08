import { User } from '../models/User';
import pool from '../core/config/conn';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

export class UserRepository {
  async save(user: Omit<User, 'id' | 'created_at'>): Promise<User> {
    const [result] = await pool.query<ResultSetHeader>(
      'INSERT INTO users (name, secondname, lastname, secondlastname, email, password, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())',
      [user.name, user.secondname, user.lastname, user.secondlastname, user.email, user.password]
    );

    const [rows] = await pool.query<RowDataPacket[]>(
      'SELECT * FROM users WHERE id = ?',
      [result.insertId]
    );

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      secondname: row.secondname,
      lastname: row.lastname,
      secondlastname: row.secondlastname,
      email: row.email,
      password: row.password,
      created_at: new Date(row.created_at)
    };
  }

  async getByEmail(email: string): Promise<User | null> {
    const [rows] = await pool.query<RowDataPacket[]>(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (rows.length === 0) return null;

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      secondname: row.secondname,
      lastname: row.lastname,
      secondlastname: row.secondlastname,
      email: row.email,
      password: row.password,
      created_at: new Date(row.created_at)
    };
  }

  async getByID(id: number): Promise<User | null> {
    const [rows] = await pool.query<RowDataPacket[]>(
      'SELECT * FROM users WHERE id = ?',
      [id]
    );

    if (rows.length === 0) return null;

    const row = rows[0];
    return {
      id: row.id,
      name: row.name,
      secondname: row.secondname,
      lastname: row.lastname,
      secondlastname: row.secondlastname,
      email: row.email,
      password: row.password,
      created_at: new Date(row.created_at)
    };
  }

  async getAll(): Promise<User[]> {
    const [rows] = await pool.query<RowDataPacket[]>('SELECT * FROM users');

    return rows.map(row => ({
      id: row.id,
      name: row.name,
      secondname: row.secondname,
      lastname: row.lastname,
      secondlastname: row.secondlastname,
      email: row.email,
      password: row.password,
      created_at: new Date(row.created_at)
    }));
  }

  async update(user: User): Promise<void> {
    await pool.query(
      'UPDATE users SET name = ?, secondname = ?, lastname = ?, secondlastname = ?, email = ?, password = ? WHERE id = ?',
      [user.name, user.secondname, user.lastname, user.secondlastname, user.email, user.password, user.id]
    );
  }

  async delete(id: number): Promise<void> {
    await pool.query('DELETE FROM users WHERE id = ?', [id]);
  }

  async getTotal(): Promise<number> {
    const [rows] = await pool.query<RowDataPacket[]>('SELECT COUNT(*) as total FROM users');
    return rows[0].total;
  }
}