import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

class ConnMongoDB {
  private mongoUri: string;

  constructor() {
    this.mongoUri = process.env.MONGO_URI || '';

    if (!this.mongoUri) {
      console.error('Error: Falta la variable MONGO_URI en el archivo .env');
      process.exit(1);
    }

    this.connect();
  }

  private async connect(): Promise<void> {
    try {
      await mongoose.connect(this.mongoUri);
      console.log('Conexion a MongoDB exitosa.');
    } catch (error) {
      console.error('Error al conectar a MongoDB:', error);
      process.exit(1);
    }
  }

  getConnection() {
    return mongoose.connection;
  }

  async close(): Promise<void> {
    await mongoose.connection.close();
    console.log('Conexion a MongoDB cerrada.');
  }

  isConnected(): boolean {
    return mongoose.connection.readyState === 1;
  }
}

const connMongoDB = new ConnMongoDB();

export default connMongoDB;