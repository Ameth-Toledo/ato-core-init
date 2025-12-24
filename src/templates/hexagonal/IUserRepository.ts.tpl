import { User } from './entities/User';
import { UserRequest } from './dto/UserRequest';

export interface IUserRepository {
  create(user: UserRequest): Promise<User>;
  findAll(): Promise<User[]>;
  findById(id: number): Promise<User | null>;
}