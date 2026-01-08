import { IUserRepository } from '../domain/IUserRepository';
import { User } from '../domain/entities/User';
import { UserRequest, LoginRequest } from '../domain/dto/UserRequest';
import { hashPassword, checkPassword } from '../../core/security/hash';
import { isValidEmail } from '../domain/utils/EmailValidator';

export class AuthService {
  constructor(private userRepository: IUserRepository) {}

  async login(loginRequest: LoginRequest): Promise<User> {
    const email = loginRequest.email.trim();

    if (!isValidEmail(email)) {
      throw new Error('Email invalido');
    }

    const user = await this.userRepository.getByEmail(email);

    if (!user) {
      throw new Error('Credenciales invalidas');
    }

    if (!user.password) {
      throw new Error('Usuario registrado con OAuth - usa login social');
    }

    const isPasswordValid = await checkPassword(user.password, loginRequest.password);

    if (!isPasswordValid) {
      throw new Error('Credenciales invalidas');
    }

    return user;
  }

  async register(userRequest: UserRequest): Promise<User> {
    const email = userRequest.email.trim();

    if (!isValidEmail(email)) {
      throw new Error('Email invalido');
    }

    const existingUser = await this.userRepository.getByEmail(email);

    if (existingUser) {
      throw new Error('El email ya esta registrado');
    }

    if (!userRequest.password || userRequest.password.length < 6) {
      throw new Error('La contraseña debe tener al menos 6 caracteres');
    }

    const hashedPassword = await hashPassword(userRequest.password);

    const newUser: Omit<User, 'id' | 'createdAt'> = {
      name: userRequest.name,
      secondname: userRequest.secondname || null,
      lastname: userRequest.lastname,
      secondlastname: userRequest.secondlastname || null,
      email: email,
      password: hashedPassword,
    };

    const savedUser = await this.userRepository.save(newUser);

    return savedUser;
  }

  async getUserByID(userId: number): Promise<User> {
    const user = await this.userRepository.getByID(userId);

    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    return user;
  }
}