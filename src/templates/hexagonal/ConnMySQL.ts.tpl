import mysql, { Pool, PoolConnection, RowDataPacket, ResultSetHeader } from 'mysql2/promise';
import dotenv from 'dotenv';

dotenv.config();

class ConnMySQL {
  private pool: Pool;

  constructor() {
    const dbHost = process.env.DB_HOST;
    const dbUser = process.env.DB_USER;
    const dbPassword = process.env.DB_PASSWORD || process.env.DB_PASS;
    const dbName = process.env.DB_NAME;
    const dbPort = process.env.DB_PORT || '3306';

    if (!dbHost || !dbUser || !dbPassword || !dbName) {
      console.error('Error: Faltan variables de entorno. Verifica tu .env');
      process.exit(1);
    }

    this.pool = mysql.createPool({
      host: dbHost,
      port: parseInt(dbPort),
      user: dbUser,
      password: dbPassword,
      database: dbName,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0,
      idleTimeout: 15 * 60 * 1000,
      enableKeepAlive: true,
      keepAliveInitialDelay: 0,
    });

    this.testConnection();
  }

  private async testConnection(): Promise<void> {
    try {
      const connection = await this.pool.getConnection();
      console.log('Conexion a MySQL exitosa.');
      connection.release();
    } catch (error) {
      console.error('Error al verificar la conexion a la base de datos:', error);
      process.exit(1);
    }
  }

  async executePreparedQuery(query: string, values: any[] = []): Promise<ResultSetHeader> {
    const connection = await this.pool.getConnection();
    try {
      const [result] = await connection.execute<ResultSetHeader>(query, values);
      return result;
    } catch (error) {
      throw new Error(`Error al ejecutar la consulta preparada: ${error}`);
    } finally {
      connection.release();
    }
  }

  async fetchRows<T extends RowDataPacket[]>(query: string, values: any[] = []): Promise<T> {
    try {
      const [rows] = await this.pool.execute<T>(query, values);
      return rows;
    } catch (error) {
      throw new Error(`Error al ejecutar la consulta SELECT: ${error}`);
    }
  }

  async getConnection(): Promise<PoolConnection> {
    return await this.pool.getConnection();
  }

  getPool(): Pool {
    return this.pool;
  }

  async close(): Promise<void> {
    await this.pool.end();
    console.log('Conexion a MySQL cerrada.');
  }
}

const connMySQL = new ConnMySQL();

export default connMySQL;