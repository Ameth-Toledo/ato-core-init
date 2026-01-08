import { IUserRepository } from '../domain/IUserRepository';

export class DeleteUserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(id: number): Promise<void> {
    const existingUser = await this.userRepository.getByID(id);

    if (!existingUser) {
      throw new Error('Usuario no encontrado');
    }

    await this.userRepository.delete(id);
  }
}