#!/usr/bin/env node

import { initDatabase } from './index';
import { logger } from './utils/logger';

const args = process.argv.slice(2);

if (args.length === 0 || args[0] !== 'init') {
  logger.error('Comando invalido. Uso: npx ato-core-init init --db=<mysql|postgres|mongo>');
  process.exit(1);
}

const dbFlag = args.find(arg => arg.startsWith('--db='));
const database = dbFlag ? dbFlag.split('=')[1] : 'mysql';

const supportedDatabases = ['mysql', 'postgres', 'mongo'];

if (!supportedDatabases.includes(database)) {
  logger.error(`Base de datos no soportada: "${database}"`);
  logger.info(`Bases de datos disponibles: ${supportedDatabases.join(', ')}`);
  process.exit(1);
}

(async () => {
  try {
    await initDatabase(database);
  } catch (error) {
    logger.error(`Error durante la inicializacion: ${error instanceof Error ? error.message : error}`);
    process.exit(1);
  }
})();