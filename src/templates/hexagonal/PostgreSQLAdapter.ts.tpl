import { IUserRepository } from '../../domain/IUserRepository';
import { User } from '../../domain/entities/User';
import pool from '../../../core/config/conn';

export class PostgreSQLUserRepository implements IUserRepository {
  async save(user: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    const query = `
      INSERT INTO users (name, secondname, lastname, secondlastname, email, password, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW())
      RETURNING *
    `;

    const result = await pool.query(query, [
      user.name,
      user.secondname,
      user.lastname,
      user.secondlastname,
      user.email,
      user.password,
    ]);

    const row = result.rows[0];
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
    const query = `SELECT * FROM users WHERE email = $1`;
    const result = await pool.query(query, [email]);

    if (result.rows.length === 0) return null;

    const row = result.rows[0];
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
    const query = `SELECT * FROM users WHERE id = $1`;
    const result = await pool.query(query, [id]);

    if (result.rows.length === 0) return null;

    const row = result.rows[0];
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
    const query = `SELECT * FROM users ORDER BY created_at DESC`;
    const result = await pool.query(query);

    return result.rows.map(row => ({
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
      SET name = $2, secondname = $3, lastname = $4, secondlastname = $5, email = $6, password = $7
      WHERE id = $1
    `;

    const result = await pool.query(query, [
      user.id,
      user.name,
      user.secondname,
      user.lastname,
      user.secondlastname,
      user.email,
      user.password,
    ]);

    if (result.rowCount === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async delete(id: number): Promise<void> {
    const query = `DELETE FROM users WHERE id = $1`;
    const result = await pool.query(query, [id]);

    if (result.rowCount === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async getTotal(): Promise<number> {
    const query = `SELECT COUNT(*) as total FROM users`;
    const result = await pool.query(query);
    return parseInt(result.rows[0].total);
  }
}