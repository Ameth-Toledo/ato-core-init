import express from 'express';
import dotenv from 'dotenv';
import userRoutes from './routes/userRoutes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use('/api', userRoutes);

app.get('/', (req, res) => {
  res.json({ 
    message: 'MVC API', 
    version: '1.0.0',
    endpoints: {
      users: '/api/users'
    }
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`API disponible en http://localhost:${PORT}/api`);
});