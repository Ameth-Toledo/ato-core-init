import { MongoDBUserRepository } from './adapters/MongoDBAdapter';
import { AuthService } from '../application/AuthService';
import { CreateUserUseCase } from '../application/CreateUserUseCase';
import { GetAllUsersUseCase } from '../application/GetAllUsersUseCase';
import { GetUserByIdUseCase } from '../application/GetUserByIdUseCase';
import { UpdateUserUseCase } from '../application/UpdateUserUseCase';
import { DeleteUserUseCase } from '../application/DeleteUserUseCase';
import { AuthController } from './controllers/AuthController';
import { CreateUserController } from './controllers/CreateUserController';
import { GetAllUsersController } from './controllers/GetAllUsersController';
import { GetUserByIdController } from './controllers/GetUserByIdController';
import { UpdateUserController } from './controllers/UpdateUserController';
import { DeleteUserController } from './controllers/DeleteUserController';

// Repository
const userRepository = new MongoDBUserRepository();

// Use Cases
const authService = new AuthService(userRepository);
const createUserUseCase = new CreateUserUseCase(userRepository);
const getAllUsersUseCase = new GetAllUsersUseCase(userRepository);
const getUserByIdUseCase = new GetUserByIdUseCase(userRepository);
const updateUserUseCase = new UpdateUserUseCase(userRepository);
const deleteUserUseCase = new DeleteUserUseCase(userRepository);

// Controllers
export const authController = new AuthController(authService);
export const createUserController = new CreateUserController(createUserUseCase);
export const getAllUsersController = new GetAllUsersController(getAllUsersUseCase);
export const getUserByIdController = new GetUserByIdController(getUserByIdUseCase);
export const updateUserController = new UpdateUserController(updateUserUseCase);
export const deleteUserController = new DeleteUserController(deleteUserUseCase);