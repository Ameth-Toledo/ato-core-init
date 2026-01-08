import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import dotenv from 'dotenv';
import { configureUserRoutes } from './src/users/infrastructure/routes/routes';
import { authController, createUserController, getAllUsersController, getUserByIdController, updateUserController, deleteUserController, } from './src/users/infrastructure/dependencies';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors({
  origin: 'frontend_web_app o *',
  credentials: true,
}));

app.use(express.json());
app.use(cookieParser());

// Routes
const userRoutes = configureUserRoutes(
  authController,
  createUserController,
  getAllUsersController,
  getUserByIdController,
  updateUserController,
  deleteUserController
);

app.use('/api', userRoutes);

// Health check
app.get('/', (req, res) => {
  res.json({ message: 'Hexagonal Architecture API - Running' });
});

// Start server
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
  console.log(`API disponible en http://localhost:${PORT}/api`);
});