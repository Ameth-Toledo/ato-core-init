import { Router } from 'express';
import { UserController } from '../controllers/UserController';
import { jwtMiddleware } from '../core/security/jwt_middleware';

const router = Router();
const userController = new UserController();

// Auth routes (public)
router.post('/auth/register', (req, res) => userController.register(req, res));
router.post('/auth/login', (req, res) => userController.login(req, res));
router.post('/auth/logout', (req, res) => userController.logout(req, res));
router.post('/auth/refresh', (req, res) => userController.refreshToken(req, res));

// Auth routes (protected)
router.get('/auth/profile', jwtMiddleware, (req, res) => userController.getProfile(req, res));
router.get('/auth/verify', jwtMiddleware, (req, res) => userController.verifyToken(req, res));

// User routes (protected)
router.get('/users', jwtMiddleware, (req, res) => userController.getAll(req, res));
router.get('/users/:id', jwtMiddleware, (req, res) => userController.getById(req, res));
router.put('/users/:id', jwtMiddleware, (req, res) => userController.update(req, res));
router.delete('/users/:id', jwtMiddleware, (req, res) => userController.delete(req, res));

export default router;