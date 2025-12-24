const express = require('express');
const dotenv = require('dotenv');
const userRoutes = require('./users/infrastructure/routes/routes');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/api', userRoutes);

app.get('/', (req, res) => {
  res.json({ message: 'Hexagonal Architecture API' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API disponible en http://localhost:${PORT}/api`);
}); 