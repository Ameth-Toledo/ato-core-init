import { Router } from 'express';
import { UserController } from '../controllers/UserController';

const router = Router();
const userController = new UserController();

router.post('/users', (req, res) => userController.create(req, res));
router.get('/users', (req, res) => userController.getAll(req, res));
router.get('/users/:id', (req, res) => userController.getById(req, res));
router.put('/users/:id', (req, res) => userController.update(req, res));
router.delete('/users/:id', (req, res) => userController.delete(req, res));

export default router;