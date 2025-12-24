import fs from 'fs';
import path from 'path';
import { logger } from './logger';

export function createDirectories(dirPath: string): void {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
  }
}

export function fileExists(filePath: string): boolean {
  return fs.existsSync(filePath);
}

export function createFileFromTemplate(templateName: string, targetPath: string): void {
  const templatePath = path.join(__dirname, '..', 'templates', templateName);

  if (!fs.existsSync(templatePath)) {
    throw new Error(`Template no encontrado: ${templatePath}`);
  }

  const content = fs.readFileSync(templatePath, 'utf-8');
  fs.writeFileSync(targetPath, content, 'utf-8');
}

export function ensureGitignore(): void {
  const gitignorePath = path.join(process.cwd(), '.gitignore');
  
  if (!fs.existsSync(gitignorePath)) {
    fs.writeFileSync(gitignorePath, '.env\nnode_modules/\n', 'utf-8');
    logger.success('Archivo .gitignore creado con .env');
    return;
  }

  const content = fs.readFileSync(gitignorePath, 'utf-8');
  const lines = content.split('\n').map(line => line.trim());

  if (!lines.includes('.env')) {
    fs.appendFileSync(gitignorePath, '\n.env\n', 'utf-8');
    logger.success('.env agregado a .gitignore');
  } else {
    logger.info('.env ya esta en .gitignore');
  }
}