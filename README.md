# ato-core-init

CLI tool y libreria para inicializar configuracion de base de datos en proyectos Node.js.

## Uso como CLI
```bash
npx ato-core-init init
npx ato-core-init init --db=mysql
npx ato-core-init init --db=postgres
npx ato-core-init init --db=mongo
```

## Uso como libreria
```bash
npm install ato-core-init
```

### TypeScript
```typescript
import { initDatabase } from 'ato-core-init';

await initDatabase('mysql');
```

### JavaScript
```javascript
const { initDatabase } = require('ato-core-init');

(async () => {
  await initDatabase('postgres');
})();
```

## Bases de datos soportadas

- MySQL (npm install mysql2)
- PostgreSQL (npm install pg)
- MongoDB (npm install mongoose)

## Estructura generada
```
proyecto/
├── core/
│   └── config/
│       └── conn.ts (o conn.js)
├── .env
├── .env.example
└── .gitignore
```

## API

### initDatabase(database: string): Promise<void>

Inicializa la configuracion de base de datos.

### detectProjectType(): 'typescript' | 'javascript'

Detecta si el proyecto usa TypeScript o JavaScript.

### createDirectories(dirPath: string): void

Crea directorios recursivamente.

### fileExists(filePath: string): boolean

Verifica si un archivo existe.

### ensureGitignore(): void

Asegura que .env este en .gitignore.

## Licencia

MIT