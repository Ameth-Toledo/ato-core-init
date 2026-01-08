import { exec } from 'child_process';
import { promisify } from 'util';
import { logger } from './logger';

const execAsync = promisify(exec);

export async function installDependencies(database: string, projectType: string): Promise<void> {
  const dependencies: string[] = ['dotenv', 'express', 'jsonwebtoken', 'bcrypt', 'cookie-parser', 'cors'];
  const devDependencies: string[] = [];

  switch (database) {
    case 'mysql':
      dependencies.push('mysql2');
      break;
    case 'postgres':
      dependencies.push('pg');
      break;
    case 'mongo':
      dependencies.push('mongoose');
      break;
  }

  if (projectType === 'typescript') {
    devDependencies.push(
      'typescript',
      '@types/node',
      '@types/express',
      '@types/jsonwebtoken',
      '@types/bcrypt',
      '@types/cookie-parser',
      '@types/cors',
      'ts-node'
    );

    if (database === 'postgres') {
      devDependencies.push('@types/pg');
    }
  }

  try {
    if (dependencies.length > 0) {
      logger.info(`Instalando dependencias: ${dependencies.join(', ')}`);
      await execAsync(`npm install ${dependencies.join(' ')}`);
    }

    if (devDependencies.length > 0) {
      logger.info(`Instalando dependencias de desarrollo: ${devDependencies.join(', ')}`);
      await execAsync(`npm install -D ${devDependencies.join(' ')}`);
    }

    logger.success('Dependencias instaladas correctamente');
  } catch (error) {
    logger.error(`Error al instalar dependencias: ${error}`);
    logger.info('Puedes instalarlas manualmente');
  }
}