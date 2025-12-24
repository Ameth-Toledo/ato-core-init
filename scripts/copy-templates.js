const fs = require('fs');
const path = require('path');

const srcTemplates = path.join(__dirname, '..', 'src', 'templates');
const distTemplates = path.join(__dirname, '..', 'dist', 'templates');

if (!fs.existsSync(distTemplates)) {
  fs.mkdirSync(distTemplates, { recursive: true });
}

const files = fs.readdirSync(srcTemplates);

files.forEach(file => {
  const srcFile = path.join(srcTemplates, file);
  const distFile = path.join(distTemplates, file);
  fs.copyFileSync(srcFile, distFile);
});

console.log('Templates copiados exitosamente');