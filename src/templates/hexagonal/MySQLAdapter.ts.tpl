import { IUserRepository } from '../../domain/IUserRepository';
import { User } from '../../domain/entities/User';
import pool from '../../../core/config/conn';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

export class MySQLUserRepository implements IUserRepository {
  async save(user: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    const query = `
      INSERT INTO users (name, secondname, lastname, secondlastname, email, password, created_at)
      VALUES (?, ?, ?, ?, ?, ?, NOW())
    `;

    const [result] = await pool.execute<ResultSetHeader>(query, [
      user.name,
      user.secondname,
      user.lastname,
      user.secondlastname,
      user.email,
      user.password,
    ]);

    const [rows] = await pool.execute<RowDataPacket[]>(
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
      createdAt: new Date(row.created_at),
    };
  }

  async getByEmail(email: string): Promise<User | null> {
    const [rows] = await pool.execute<RowDataPacket[]>(
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
      createdAt: new Date(row.created_at),
    };
  }

  async getByID(id: number): Promise<User | null> {
    const [rows] = await pool.execute<RowDataPacket[]>(
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
      createdAt: new Date(row.created_at),
    };
  }

  async getAll(): Promise<User[]> {
    const [rows] = await pool.execute<RowDataPacket[]>(
      'SELECT * FROM users ORDER BY created_at DESC'
    );

    return rows.map(row => ({
      id: row.id,
      name: row.name,
      secondname: row.secondname,
      lastname: row.lastname,
      secondlastname: row.secondlastname,
      email: row.email,
      password: row.password,
      createdAt: new Date(row.created_at),
    }));
  }

  async update(user: User): Promise<void> {
    const query = `
      UPDATE users 
      SET name = ?, secondname = ?, lastname = ?, secondlastname = ?, email = ?, password = ?
      WHERE id = ?
    `;

    const [result] = await pool.execute<ResultSetHeader>(query, [
      user.name,
      user.secondname,
      user.lastname,
      user.secondlastname,
      user.email,
      user.password,
      user.id,
    ]);

    if (result.affectedRows === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async delete(id: number): Promise<void> {
    const [result] = await pool.execute<ResultSetHeader>(
      'DELETE FROM users WHERE id = ?',
      [id]
    );

    if (result.affectedRows === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async getTotal(): Promise<number> {
    const [rows] = await pool.execute<RowDataPacket[]>(
      'SELECT COUNT(*) as total FROM users'
    );
    return rows[0].total;
  }
}