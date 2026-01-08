# ato-core-init

🚀 CLI tool para generar proyectos Node.js con arquitectura MVC o Hexagonal, configuración de base de datos y autenticación JWT lista para usar.

## ✨ Características

- 🏗️ **Arquitecturas**: MVC y Hexagonal (Vertical Slice)
- 🗄️ **Bases de datos**: MySQL, PostgreSQL, MongoDB
- 🔐 **Autenticación JWT** con HttpOnly cookies
- 🔒 **Seguridad**: bcrypt, hash de passwords, middleware JWT
- 📝 **TypeScript** y JavaScript
- 📦 **Todo listo**: Estructura completa con CRUD de usuarios
- 🎯 **Zero config**: Solo ejecuta y empieza a codear

---

## 🚀 Inicio rápido

### Crear proyecto completo (recomendado)
```bash
# Proyecto MVC con MySQL (por defecto)
npx ato-core-init create --db=mysql

# Hexagonal con PostgreSQL
npx ato-core-init create --db=postgres --architecture=hexagonal

# Con TypeScript
npx ato-core-init create --db=mongo --lang=typescript
```

### Solo configuración de base de datos
```bash
npx ato-core-init init --db=mysql
```

---

## 📋 Comandos

### `create` - Proyecto completo

Genera un proyecto completo con estructura, autenticación y CRUD.
```bash
npx ato-core-init create [opciones]
```

**Opciones:**
- `--db=<mysql|postgres|mongo>` - Base de datos (requerido)
- `--architecture=<mvc|hexagonal>` - Arquitectura (default: mvc)
- `--lang=<typescript|javascript>` - Lenguaje (default: detectado o javascript)

**Ejemplos:**
```bash
# MVC con MySQL y TypeScript
npx ato-core-init create --db=mysql --lang=typescript

# Hexagonal con PostgreSQL
npx ato-core-init create --db=postgres --architecture=hexagonal

# MVC con MongoDB y JavaScript
npx ato-core-init create --db=mongo --lang=javascript
```

### `init` - Solo configuración de DB

Genera únicamente la configuración de base de datos en un proyecto existente.
```bash
npx ato-core-init init --db=<mysql|postgres|mongo>
```

---

## 🏗️ Arquitecturas

### MVC (Model-View-Controller)

Estructura simple y directa para proyectos tradicionales.
```
src/
├── controllers/      # Controladores HTTP
├── models/          # Interfaces/Tipos
├── repositories/    # Acceso a datos
├── services/        # Lógica de negocio
├── routes/          # Rutas Express
└── core/
    ├── config/      # Conexión DB
    └── security/    # Auth, JWT, Hash
```

**Endpoints generados:**
```
POST   /api/auth/register
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh
GET    /api/auth/profile  (protegido)
GET    /api/users         (protegido)
GET    /api/users/:id     (protegido)
PUT    /api/users/:id     (protegido)
DELETE /api/users/:id     (protegido)
```

### Hexagonal (Vertical Slice)

Arquitectura limpia con separación por dominio.
```
src/
└── users/
    ├── application/          # Casos de uso
    │   ├── AuthService.ts
    │   ├── CreateUserUseCase.ts
    │   ├── GetAllUsersUseCase.ts
    │   └── ...
    ├── domain/              # Lógica de negocio
    │   ├── entities/
    │   ├── dto/
    │   ├── utils/
    │   └── IUserRepository.ts
    └── infrastructure/      # Adaptadores externos
        ├── adapters/        # MySQL, PostgreSQL, MongoDB
        ├── controllers/     # HTTP handlers
        ├── routes/
        └── dependencies.ts
```

**Mismos endpoints** que MVC.

---

## 🗄️ Bases de datos

### MySQL
```bash
npx ato-core-init create --db=mysql
```

**Variables de entorno (.env):**
```env
DB_HOST=localhost
DB_USER=root
DB_PASS=
DB_NAME=mydb
```

**Crear base de datos:**
```bash
mysql -u root -p < schema.sql
```

### PostgreSQL
```bash
npx ato-core-init create --db=postgres
```

**Variables de entorno (.env):**
```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=
DB_NAME=mydb
DB_SSL=false
```

**Crear base de datos:**
```bash
psql -U postgres -f schema.sql
```

### MongoDB
```bash
npx ato-core-init create --db=mongo
```

**Variables de entorno (.env):**
```env
MONGO_URI=mongodb://localhost:27017/mydb
```

---

## 🔐 Autenticación

El proyecto incluye autenticación JWT completa con HttpOnly cookies.

### Registrar usuario
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John",
    "lastname": "Doe",
    "email": "john@example.com",
    "password": "123456"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -c cookies.txt \
  -d '{
    "email": "john@example.com",
    "password": "123456"
  }'
```

### Obtener perfil (requiere autenticación)
```bash
curl -X GET http://localhost:3000/api/auth/profile \
  -b cookies.txt
```

### Refresh token
```bash
curl -X POST http://localhost:3000/api/auth/refresh \
  -b cookies.txt
```

### Logout
```bash
curl -X POST http://localhost:3000/api/auth/logout \
  -b cookies.txt
```

---

## 🚀 Ejecutar el proyecto

### Con TypeScript
```bash
# Desarrollo
npm run dev

# Producción
npm run build
npm start
```

### Con JavaScript
```bash
npm start
```

---

## 📦 Uso como librería

### Instalación
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

---

## 🛠️ Tecnologías incluidas

- **Express** - Framework web
- **JWT** - Autenticación con tokens
- **bcrypt** - Hash de passwords
- **cookie-parser** - Manejo de cookies
- **cors** - Cross-Origin Resource Sharing
- **dotenv** - Variables de entorno
- **MySQL2 / pg / mongoose** - Drivers de bases de datos

---

## 📝 Schema de base de datos

El proyecto genera automáticamente un archivo `schema.sql` (MySQL/PostgreSQL) con la siguiente estructura:
```sql
CREATE TABLE users (
    id INT/SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    secondname VARCHAR(50),
    lastname VARCHAR(50) NOT NULL,
    secondlastname VARCHAR(50),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔒 Seguridad

### HttpOnly Cookies

Los tokens JWT se almacenan en cookies HttpOnly para proteger contra ataques XSS:
```typescript
res.cookie('access_token', token, {
  httpOnly: true,      // No accesible desde JavaScript
  secure: true,        // Solo HTTPS en producción
  sameSite: 'strict',  // Protección CSRF
  maxAge: 15 * 60 * 1000 // 15 minutos
});
```

### Middleware JWT
```typescript
import { jwtMiddleware } from './core/security/jwt_middleware';

// Proteger rutas
router.get('/users', jwtMiddleware, userController.getAll);
```

### Hash de passwords
```typescript
import { hashPassword, checkPassword } from './core/security/hash';

const hashedPassword = await hashPassword('123456');
const isValid = await checkPassword(hashedPassword, '123456');
```

---

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

## 📄 Licencia

MIT © Ameth Toledo

---

## 🐛 Reportar bugs

Si encuentras algún problema, por favor abre un issue en:
https://github.com/Ameth-Toledo/ato-core-init/issues

---

## 📞 Soporte

- GitHub: [@Ameth-Toledo](https://github.com/Ameth-Toledo)
- npm: [ato-core-init](https://www.npmjs.com/package/ato-core-init)

---

**¡Hecho con ❤️ para la comunidad de desarrolladores!**