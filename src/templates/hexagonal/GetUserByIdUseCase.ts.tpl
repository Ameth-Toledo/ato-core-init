import { IUserRepository } from '../domain/IUserRepository';
import { User } from '../domain/entities/User';

export class GetUserByIdUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(id: number): Promise<User> {
    const user = await this.userRepository.getByID(id);

    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    return user;
  }
}