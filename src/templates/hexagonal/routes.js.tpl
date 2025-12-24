const { Router } = require('express');
const { createUserController, getAllUsersController } = require('./dependencies');

const router = Router();

router.post('/users', (req, res) => createUserController.handle(req, res));
router.get('/users', (req, res) => getAllUsersController.handle(req, res));

module.exports = router;