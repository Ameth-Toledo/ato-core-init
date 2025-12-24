import { MySQLUserRepository } from './adapters/MySQLAdapter';
import { CreateUserUseCase } from '../application/CreateUserUseCase';
import { GetAllUsersUseCase } from '../application/GetAllUsersUseCase';
import { CreateUserController } from './controllers/CreateUserController';
import { GetAllUsersController } from './controllers/GetAllUsersController';

const userRepository = new MySQLUserRepository();

const createUserUseCase = new CreateUserUseCase(userRepository);
const getAllUsersUseCase = new GetAllUsersUseCase(userRepository);

export const createUserController = new CreateUserController(createUserUseCase);
export const getAllUsersController = new GetAllUsersController(getAllUsersUseCase);