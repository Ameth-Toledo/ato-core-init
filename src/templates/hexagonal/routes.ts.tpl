import { Router } from 'express';
import { AuthController } from '../controllers/AuthController';
import { CreateUserController } from '../controllers/CreateUserController';
import { GetAllUsersController } from '../controllers/GetAllUsersController';
import { GetUserByIdController } from '../controllers/GetUserByIdController';
import { UpdateUserController } from '../controllers/UpdateUserController';
import { DeleteUserController } from '../controllers/DeleteUserController';
import { jwtMiddleware } from '../../../core/security/jwt_middleware';

export function configureUserRoutes(
  authCtrl: AuthController,
  createUserCtrl: CreateUserController,
  getAllUsersCtrl: GetAllUsersController,
  getUserByIdCtrl: GetUserByIdController,
  updateUserCtrl: UpdateUserController,
  deleteUserCtrl: DeleteUserController
): Router {
  const router = Router();

  // Auth routes
  router.post('/auth/login', (req, res) => authCtrl.login(req, res));
  router.post('/auth/register', (req, res) => createUserCtrl.execute(req, res));
  router.post('/auth/logout', (req, res) => authCtrl.logout(req, res));
  router.post('/auth/refresh', (req, res) => authCtrl.refreshToken(req, res));
  router.get('/auth/profile', jwtMiddleware, (req, res) => authCtrl.getProfile(req, res));
  router.get('/auth/verify', jwtMiddleware, (req, res) => authCtrl.verifyToken(req, res));

  // User routes (protected)
  router.get('/users', jwtMiddleware, (req, res) => getAllUsersCtrl.execute(req, res));
  router.get('/users/:id', jwtMiddleware, (req, res) => getUserByIdCtrl.execute(req, res));
  router.put('/users/:id', jwtMiddleware, (req, res) => updateUserCtrl.execute(req, res));
  router.delete('/users/:id', jwtMiddleware, (req, res) => deleteUserCtrl.execute(req, res));

  return router;
}