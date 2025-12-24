import { IUserRepository } from '../domain/IUserRepository';
import { UserRequest } from '../domain/dto/UserRequest';
import { UserResponse } from '../domain/dto/UserResponse';

export class CreateUserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(userRequest: UserRequest): Promise<UserResponse> {
    const user = await this.userRepository.create(userRequest);

    return {
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toISOString()
    };
  }
}