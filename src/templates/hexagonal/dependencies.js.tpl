const { MySQLUserRepository } = require('./adapters/MySQLAdapter');
const { CreateUserUseCase } = require('../application/CreateUserUseCase');
const { GetAllUsersUseCase } = require('../application/GetAllUsersUseCase');
const { CreateUserController } = require('./controllers/CreateUserController');
const { GetAllUsersController } = require('./controllers/GetAllUsersController');

const userRepository = new MySQLUserRepository();

const createUserUseCase = new CreateUserUseCase(userRepository);
const getAllUsersUseCase = new GetAllUsersUseCase(userRepository);

const createUserController = new CreateUserController(createUserUseCase);
const getAllUsersController = new GetAllUsersController(getAllUsersUseCase);

module.exports = {
  createUserController,
  getAllUsersController
};