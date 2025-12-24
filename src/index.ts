import { createDirectories, createFileFromTemplate, fileExists, ensureGitignore } from './utils/fileSystem';
import { detectProjectType } from './utils/detector';
import { logger } from './utils/logger';
import path from 'path';

export async function initDatabase(database: string): Promise<void> {
  logger.info(`Inicializando configuracion para ${database.toUpperCase()}...`);

  const projectType = detectProjectType();
  const extension = projectType === 'typescript' ? 'ts' : 'js';

  logger.info(`Proyecto detectado: ${projectType === 'typescript' ? 'TypeScript' : 'JavaScript'}`);

  const targetDir = path.join(process.cwd(), 'core', 'config');
  createDirectories(targetDir);

  const connFile = path.join(targetDir, `conn.${extension}`);
  const templateFile = `conn.${database}.${extension}.tpl`;

  if (fileExists(connFile)) {
    logger.warn(`El archivo ${connFile} ya existe. No se sobrescribira.`);
  } else {
    createFileFromTemplate(templateFile, connFile);
    logger.success(`Archivo creado: ${connFile}`);
  }

  const envExampleFile = path.join(process.cwd(), '.env.example');
  const envExampleTemplate = `env.${database}.tpl`;

  createFileFromTemplate(envExampleTemplate, envExampleFile);
  logger.success(`Archivo creado: ${envExampleFile}`);

  const envFile = path.join(process.cwd(), '.env');

  if (fileExists(envFile)) {
    logger.warn(`El archivo .env ya existe. No se sobrescribira.`);
  } else {
    createFileFromTemplate(envExampleTemplate, envFile);
    logger.success(`Archivo creado: ${envFile}`);
  }

  ensureGitignore();

  logger.info('\nInstrucciones:');
  
  switch (database) {
    case 'mysql':
      logger.info('Instala las dependencias: npm install mysql2');
      break;
    case 'postgres':
      logger.info('Instala las dependencias: npm install pg');
      break;
    case 'mongo':
      logger.info('Instala las dependencias: npm install mongoose');
      break;
  }

  logger.info('Configura las variables de entorno en .env');
  logger.success('\nConfiguracion completada con exito!');
}

export { detectProjectType } from './utils/detector';
export { createDirectories, fileExists, ensureGitignore } from './utils/fileSystem';