import { IUserRepository } from '../domain/IUserRepository';
import { UserResponse } from '../domain/dto/UserResponse';

export class GetAllUsersUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(): Promise<UserResponse[]> {
    const users = await this.userRepository.findAll();

    return users.map(user => ({
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toISOString()
    }));
  }
}