import { UserRepository } from '../repositories/UserRepository';
import { User } from '../models/User';
import { hashPassword, checkPassword } from '../core/security/hash';
import { isValidEmail } from '../core/security/utils';

export class UserService {
  private userRepository: UserRepository;

  constructor() {
    this.userRepository = new UserRepository();
  }

  async register(userData: {
    name: string;
    secondname?: string;
    lastname: string;
    secondlastname?: string;
    email: string;
    password: string;
  }): Promise<User> {
    const email = userData.email.trim().toLowerCase();

    if (!isValidEmail(email)) {
      throw new Error('Email invalido');
    }

    const existingUser = await this.userRepository.getByEmail(email);
    if (existingUser) {
      throw new Error('El email ya esta registrado');
    }

    if (!userData.password || userData.password.length < 6) {
      throw new Error('La contraseña debe tener al menos 6 caracteres');
    }

    const hashedPassword = await hashPassword(userData.password);

    const newUser = {
      name: userData.name.trim(),
      secondname: userData.secondname?.trim() || null,
      lastname: userData.lastname.trim(),
      secondlastname: userData.secondlastname?.trim() || null,
      email: email,
      password: hashedPassword,
    };

    return await this.userRepository.save(newUser);
  }

  async login(email: string, password: string): Promise<User> {
    const trimmedEmail = email.trim().toLowerCase();

    if (!isValidEmail(trimmedEmail)) {
      throw new Error('Email invalido');
    }

    const user = await this.userRepository.getByEmail(trimmedEmail);

    if (!user) {
      throw new Error('Credenciales invalidas');
    }

    const isPasswordValid = await checkPassword(user.password, password);

    if (!isPasswordValid) {
      throw new Error('Credenciales invalidas');
    }

    return user;
  }

  async getAllUsers(): Promise<User[]> {
    return await this.userRepository.getAll();
  }

  async getUserById(id: number): Promise<User> {
    const user = await this.userRepository.getByID(id);

    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    return user;
  }

  async updateUser(id: number, userData: {
    name: string;
    secondname?: string;
    lastname: string;
    secondlastname?: string;
    email: string;
  }): Promise<User> {
    const existingUser = await this.userRepository.getByID(id);

    if (!existingUser) {
      throw new Error('Usuario no encontrado');
    }

    const email = userData.email.trim().toLowerCase();

    if (!isValidEmail(email)) {
      throw new Error('Email invalido');
    }

    const updatedUser: User = {
      ...existingUser,
      name: userData.name.trim(),
      secondname: userData.secondname?.trim() || null,
      lastname: userData.lastname.trim(),
      secondlastname: userData.secondlastname?.trim() || null,
      email: email,
    };

    await this.userRepository.update(updatedUser);

    return updatedUser;
  }

  async deleteUser(id: number): Promise<void> {
    const user = await this.userRepository.getByID(id);

    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    await this.userRepository.delete(id);
  }

  async getTotal(): Promise<number> {
    return await this.userRepository.getTotal();
  }
}