#!/usr/bin/env node

import { initDatabase } from './index';
import { createProject } from './createProject';
import { logger } from './utils/logger';

const args = process.argv.slice(2);
const command = args[0];

if (!command || !['init', 'create'].includes(command)) {
  logger.error('Comando invalido. Uso:');
  logger.info('  npx ato-core-init init --db=<mysql|postgres|mongo>');
  logger.info('  npx ato-core-init create --db=<mysql|postgres|mongo> [--architecture=<mvc|hexagonal>] [--lang=<typescript|javascript>]');
  process.exit(1);
}

const dbFlag = args.find(arg => arg.startsWith('--db='));
const database = dbFlag ? dbFlag.split('=')[1] : 'mysql';

const architectureFlag = args.find(arg => arg.startsWith('--architecture='));
const architecture = architectureFlag ? architectureFlag.split('=')[1] : 'mvc';

const langFlag = args.find(arg => arg.startsWith('--lang='));
const language = langFlag ? langFlag.split('=')[1] : null;

const supportedDatabases = ['mysql', 'postgres', 'mongo'];
const supportedArchitectures = ['mvc', 'hexagonal'];

if (!supportedDatabases.includes(database)) {
  logger.error(`Base de datos no soportada: "${database}"`);
  logger.info(`Bases de datos disponibles: ${supportedDatabases.join(', ')}`);
  process.exit(1);
}

if (!supportedArchitectures.includes(architecture)) {
  logger.error(`Arquitectura no soportada: "${architecture}"`);
  logger.info(`Arquitecturas disponibles: ${supportedArchitectures.join(', ')}`);
  process.exit(1);
}

(async () => {
  try {
    if (command === 'init') {
      await initDatabase(database);
    } else if (command === 'create') {
      await createProject(database, architecture, language);
    }
  } catch (error) {
    logger.error(`Error durante la ejecucion: ${error instanceof Error ? error.message : error}`);
    process.exit(1);
  }
})();