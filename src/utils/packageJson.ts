import fs from 'fs';
import path from 'path';

export function createPackageJson(database: string, projectType: string, architecture: string): void {
  const packageJson = {
    name: path.basename(process.cwd()),
    version: '1.0.0',
    description: `${architecture.toUpperCase()} architecture project`,
    main: projectType === 'typescript' ? 'dist/main.js' : 'main.js',
    scripts: projectType === 'typescript'
      ? {
          build: 'tsc',
          dev: 'ts-node main.ts',
          start: 'node dist/main.js'
        }
      : {
          start: 'node main.js'
        },
    keywords: [architecture, database],
    author: '',
    license: 'ISC',
    dependencies: {},
    devDependencies: {}
  };

  fs.writeFileSync(
    path.join(process.cwd(), 'package.json'),
    JSON.stringify(packageJson, null, 2),
    'utf-8'
  );
}