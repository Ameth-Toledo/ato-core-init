import { Pool, PoolClient, QueryResult } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

class ConnPostgreSQL {
  private pool: Pool;

  constructor() {
    const dbHost = process.env.DB_HOST;
    const dbUser = process.env.DB_USER;
    const dbPassword = process.env.DB_PASSWORD || process.env.DB_PASS;
    const dbName = process.env.DB_NAME;
    const dbPort = process.env.DB_PORT || '5432';
    const dbSSL = process.env.DB_SSL || 'false';

    if (!dbHost || !dbUser || !dbPassword || !dbName) {
      console.error('Error: Faltan variables de entorno. Verifica tu .env');
      process.exit(1);
    }

    const sslMode = dbSSL === 'false' ? false : { rejectUnauthorized: false };

    this.pool = new Pool({
      host: dbHost,
      port: parseInt(dbPort),
      user: dbUser,
      password: dbPassword,
      database: dbName,
      ssl: sslMode,
      max: 10,
      idleTimeoutMillis: 15 * 60 * 1000,
      connectionTimeoutMillis: 2000,
    });

    this.testConnection();
  }

  private async testConnection(): Promise<void> {
    try {
      const client = await this.pool.connect();
      console.log('Conexion a PostgreSQL exitosa.');
      client.release();
    } catch (error) {
      console.error('Error al verificar la conexion a la base de datos:', error);
      process.exit(1);
    }
  }

  async executePreparedQuery(query: string, values: any[] = []): Promise<QueryResult> {
    const client = await this.pool.connect();
    try {
      const result = await client.query(query, values);
      return result;
    } catch (error) {
      throw new Error(`Error al ejecutar la consulta preparada: ${error}`);
    } finally {
      client.release();
    }
  }

  async fetchRows(query: string, values: any[] = []): Promise<QueryResult> {
    try {
      const result = await this.pool.query(query, values);
      return result;
    } catch (error) {
      throw new Error(`Error al ejecutar la consulta SELECT: ${error}`);
    }
  }

  async getClient(): Promise<PoolClient> {
    return await this.pool.connect();
  }

  getPool(): Pool {
    return this.pool;
  }

  async close(): Promise<void> {
    await this.pool.end();
    console.log('Conexion a PostgreSQL cerrada.');
  }
}

const connPostgreSQL = new ConnPostgreSQL();

export default connPostgreSQL;