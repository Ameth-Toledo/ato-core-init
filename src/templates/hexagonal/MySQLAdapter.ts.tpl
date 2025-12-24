import { IUserRepository } from '../../domain/IUserRepository';
import { User } from '../../domain/entities/User';
import { UserRequest } from '../../domain/dto/UserRequest';
import pool from '../../../core/config/conn';
import { RowDataPacket, ResultSetHeader } from 'mysql2';

export class MySQLUserRepository implements IUserRepository {
  async create(userRequest: UserRequest): Promise<User> {
    const [result] = await pool.query<ResultSetHeader>(
      'INSERT INTO users (name, email, created_at) VALUES (?, ?, NOW())',
      [userRequest.name, userRequest.email]
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
}