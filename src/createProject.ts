import { createDirectories, createFileFromTemplate } from './utils/fileSystem';
import { logger } from './utils/logger';
import { installDependencies } from './utils/installer';
import { createPackageJson } from './utils/packageJson';
import path from 'path';
import fs from 'fs';

export async function createProject(
  database: string,
  architecture: string,
  language: string | null
): Promise<void> {
  const projectType = language || 'javascript';
  const extension = projectType === 'typescript' ? 'ts' : 'js';

  logger.info(`Creando proyecto con arquitectura ${architecture.toUpperCase()} y base de datos ${database.toUpperCase()}...`);
  logger.info(`Lenguaje seleccionado: ${projectType === 'typescript' ? 'TypeScript' : 'JavaScript'}`);

  if (architecture === 'hexagonal') {
    await createHexagonalProject(database, extension);
  } else {
    await createMVCProject(database, extension);
  }

  createEnvFiles(database);
  createGitignore();
  createPackageJson(database, projectType, architecture);
  logger.success('Archivo creado: package.json');

  if (projectType === 'typescript') {
    createTypeScriptConfig();
    logger.success('Archivo creado: tsconfig.json');
  }

  createMainFile(extension, architecture);
  logger.success(`Archivo creado: main.${extension}`);

  logger.info('\nInstalando dependencias...');
  await installDependencies(database, projectType);

  logger.success('\nProyecto creado exitosamente!');
  printProjectStructure(architecture);
  logger.info('\nPasos siguientes:');
  logger.info('1. Configura las variables de entorno en .env');
  logger.info(`2. Ejecuta: ${projectType === 'typescript' ? 'npm run dev' : 'npm start'}`);
}

async function createMVCProject(database: string, extension: string): Promise<void> {
  const folders = [
    'src/controllers',
    'src/models',
    'src/repositories',
    'src/services',
    'src/routes',
    'src/core/config'
  ];

  folders.forEach(folder => {
    const fullPath = path.join(process.cwd(), folder);
    createDirectories(fullPath);
  });

  logger.success('Estructura MVC creada');

  const mvcFiles = [
    { template: `mvc/User.${extension}.tpl`, output: `src/models/User.${extension}` },
    { template: `mvc/UserRepository.${extension}.tpl`, output: `src/repositories/UserRepository.${extension}` },
    { template: `mvc/UserService.${extension}.tpl`, output: `src/services/UserService.${extension}` },
    { template: `mvc/UserController.${extension}.tpl`, output: `src/controllers/UserController.${extension}` },
    { template: `mvc/userRoutes.${extension}.tpl`, output: `src/routes/userRoutes.${extension}` }
  ];

  mvcFiles.forEach(file => {
    createFileFromTemplate(file.template, path.join(process.cwd(), file.output));
    logger.success(`Archivo creado: ${file.output}`);
  });

  const connFile = path.join(process.cwd(), 'src', 'core', 'config', `conn.${extension}`);
  const templateFile = `conn.${database}.${extension}.tpl`;
  createFileFromTemplate(templateFile, connFile);
  logger.success(`Archivo creado: src/core/config/conn.${extension}`);
}

async function createHexagonalProject(database: string, extension: string): Promise<void> {
  const folders = [
    'src/users/application',
    'src/users/domain/entities',
    'src/users/domain/dto',
    'src/users/infrastructure/adapters',
    'src/users/infrastructure/controllers',
    'src/users/infrastructure/routes',
    'src/core/config'
  ];

  folders.forEach(folder => {
    const fullPath = path.join(process.cwd(), folder);
    createDirectories(fullPath);
  });

  logger.success('Estructura hexagonal creada');

  const domainFiles = [
    { template: `hexagonal/User.${extension}.tpl`, output: `src/users/domain/entities/User.${extension}` },
    { template: `hexagonal/UserRequest.${extension}.tpl`, output: `src/users/domain/dto/UserRequest.${extension}` },
    { template: `hexagonal/UserResponse.${extension}.tpl`, output: `src/users/domain/dto/UserResponse.${extension}` },
    { template: `hexagonal/IUserRepository.${extension}.tpl`, output: `src/users/domain/IUserRepository.${extension}` }
  ];

  domainFiles.forEach(file => {
    createFileFromTemplate(file.template, path.join(process.cwd(), file.output));
    logger.success(`Archivo creado: ${file.output}`);
  });

  const applicationFiles = [
    { template: `hexagonal/CreateUserUseCase.${extension}.tpl`, output: `src/users/application/CreateUserUseCase.${extension}` },
    { template: `hexagonal/GetAllUsersUseCase.${extension}.tpl`, output: `src/users/application/GetAllUsersUseCase.${extension}` }
  ];

  applicationFiles.forEach(file => {
    createFileFromTemplate(file.template, path.join(process.cwd(), file.output));
    logger.success(`Archivo creado: ${file.output}`);
  });

  const adapterMap: { [key: string]: string } = {
    mysql: 'MySQL',
    postgres: 'PostgreSQL',
    mongo: 'MongoDB'
  };

  const adapterName = adapterMap[database];

  const infrastructureFiles = [
    { template: `hexagonal/${adapterName}Adapter.${extension}.tpl`, output: `src/users/infrastructure/adapters/${adapterName}Adapter.${extension}` },
    { template: `hexagonal/CreateUserController.${extension}.tpl`, output: `src/users/infrastructure/controllers/CreateUserController.${extension}` },
    { template: `hexagonal/GetAllUsersController.${extension}.tpl`, output: `src/users/infrastructure/controllers/GetAllUsersController.${extension}` },
    { template: `hexagonal/routes.${extension}.tpl`, output: `src/users/infrastructure/routes/routes.${extension}` },
    { template: `hexagonal/dependencies.${extension}.tpl`, output: `src/users/infrastructure/dependencies.${extension}` }
  ];

  infrastructureFiles.forEach(file => {
    createFileFromTemplate(file.template, path.join(process.cwd(), file.output));
    logger.success(`Archivo creado: ${file.output}`);
  });

  const connFile = path.join(process.cwd(), 'src', 'core', 'config', `conn.${extension}`);
  const templateFile = `conn.${database}.${extension}.tpl`;
  createFileFromTemplate(templateFile, connFile);
  logger.success(`Archivo creado: src/core/config/conn.${extension}`);
}

function createEnvFiles(database: string): void {
  const envExampleFile = path.join(process.cwd(), '.env.example');
  const envFile = path.join(process.cwd(), '.env');
  const envTemplate = `env.${database}.tpl`;

  createFileFromTemplate(envTemplate, envExampleFile);
  logger.success('Archivo creado: .env.example');

  if (!fs.existsSync(envFile)) {
    createFileFromTemplate(envTemplate, envFile);
    logger.success('Archivo creado: .env');
  }
}

function createGitignore(): void {
  const gitignorePath = path.join(process.cwd(), '.gitignore');

  if (!fs.existsSync(gitignorePath)) {
    fs.writeFileSync(gitignorePath, 'node_modules/\n.env\ndist/\n*.log\n.DS_Store\n', 'utf-8');
    logger.success('Archivo .gitignore creado');
  } else {
    const content = fs.readFileSync(gitignorePath, 'utf-8');
    if (!content.includes('.env')) {
      fs.appendFileSync(gitignorePath, '\n.env\n', 'utf-8');
      logger.success('.env agregado a .gitignore');
    }
  }
}

function createTypeScriptConfig(): void {
  const tsconfig = {
    compilerOptions: {
      target: 'ES2020',
      module: 'commonjs',
      lib: ['ES2020'],
      outDir: './dist',
      rootDir: './src',
      strict: true,
      esModuleInterop: true,
      skipLibCheck: true,
      forceConsistentCasingInFileNames: true,
      resolveJsonModule: true,
      moduleResolution: 'node'
    },
    include: ['src/**/*'],
    exclude: ['node_modules', 'dist']
  };

  fs.writeFileSync(
    path.join(process.cwd(), 'tsconfig.json'),
    JSON.stringify(tsconfig, null, 2),
    'utf-8'
  );
}

function createMainFile(extension: string, architecture: string): void {
  const templateFile = architecture === 'hexagonal' 
    ? `hexagonal/main.${extension}.tpl`
    : `mvc/main.${extension}.tpl`;
  
  createFileFromTemplate(templateFile, path.join(process.cwd(), `main.${extension}`));
}

function printProjectStructure(architecture: string): void {
  logger.info('\nEstructura creada:');
  
  if (architecture === 'mvc') {
    logger.info('src/controllers/');
    logger.info('src/models/');
    logger.info('src/repositories/');
    logger.info('src/services/');
    logger.info('src/routes/');
    logger.info('src/core/config/');
  } else {
    logger.info('src/users/application/');
    logger.info('src/users/domain/');
    logger.info('src/users/infrastructure/');
    logger.info('src/core/config/');
  }
}