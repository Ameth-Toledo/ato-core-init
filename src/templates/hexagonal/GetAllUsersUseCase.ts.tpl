import { IUserRepository } from '../domain/IUserRepository';
import { User } from '../domain/entities/User';

export class GetAllUsersUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(): Promise<User[]> {
    return await this.userRepository.getAll();
  }
}