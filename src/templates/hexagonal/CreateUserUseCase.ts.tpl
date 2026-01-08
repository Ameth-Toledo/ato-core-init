import { IUserRepository } from '../domain/IUserRepository';
import { User } from '../domain/entities/User';
import { UserRequest } from '../domain/dto/UserRequest';
import { hashPassword } from '../../core/security/hash';
import { isValidEmail } from '../domain/utils/EmailValidator';

export class CreateUserUseCase {
  constructor(private userRepository: IUserRepository) {}

  async execute(userRequest: UserRequest): Promise<User> {
    if (!userRequest.name || userRequest.name.trim() === '') {
      throw new Error('El nombre es obligatorio');
    }

    if (!userRequest.lastname || userRequest.lastname.trim() === '') {
      throw new Error('El apellido es obligatorio');
    }

    if (!userRequest.email || userRequest.email.trim() === '') {
      throw new Error('El email es obligatorio');
    }

    if (!isValidEmail(userRequest.email)) {
      throw new Error('El email no es valido');
    }

    if (!userRequest.password || userRequest.password.length < 6) {
      throw new Error('La contraseña debe tener al menos 6 caracteres');
    }

    const existingUser = await this.userRepository.getByEmail(userRequest.email);
    if (existingUser) {
      throw new Error('El email ya esta registrado');
    }

    const hashedPassword = await hashPassword(userRequest.password);

    const newUser: Omit<User, 'id' | 'createdAt'> = {
      name: userRequest.name.trim(),
      secondname: userRequest.secondname?.trim() || null,
      lastname: userRequest.lastname.trim(),
      secondlastname: userRequest.secondlastname?.trim() || null,
      email: userRequest.email.trim().toLowerCase(),
      password: hashedPassword,
    };

    return await this.userRepository.save(newUser);
  }
}