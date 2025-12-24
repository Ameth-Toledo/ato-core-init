import fs from 'fs';
import path from 'path';

export function detectProjectType(): 'typescript' | 'javascript' {
  const tsconfigPath = path.join(process.cwd(), 'tsconfig.json');
  return fs.existsSync(tsconfigPath) ? 'typescript' : 'javascript';
}