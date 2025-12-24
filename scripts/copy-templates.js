const fs = require('fs');
const path = require('path');

const srcTemplates = path.join(__dirname, '..', 'src', 'templates');
const distTemplates = path.join(__dirname, '..', 'dist', 'templates');

function copyRecursive(src, dest) {
  if (!fs.existsSync(dest)) {
    fs.mkdirSync(dest, { recursive: true });
  }

  const entries = fs.readdirSync(src, { withFileTypes: true });

  for (const entry of entries) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);

    if (entry.isDirectory()) {
      copyRecursive(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
      console.log(`Copiado: ${entry.name}`);
    }
  }
}

copyRecursive(srcTemplates, distTemplates);
console.log('Templates copiados exitosamente');