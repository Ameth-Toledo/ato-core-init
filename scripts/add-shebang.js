const fs = require('fs');
const path = require('path');

const cliPath = path.join(__dirname, '..', 'dist', 'cli.js');

if (!fs.existsSync(cliPath)) {
  console.error('Error: dist/cli.js no existe');
  process.exit(1);
}

const content = fs.readFileSync(cliPath, 'utf-8');

if (!content.startsWith('#!/usr/bin/env node')) {
  const newContent = '#!/usr/bin/env node\n' + content;
  fs.writeFileSync(cliPath, newContent, 'utf-8');
  console.log('Shebang agregado a dist/cli.js');
} else {
  console.log('Shebang ya existe en dist/cli.js');
}

fs.chmodSync(cliPath, '755');
console.log('Permisos de ejecucion agregados a dist/cli.js');