import { UserRepository } from '../repositories/UserRepository';
import { User } from '../models/User';

export class UserService {
  private userRepository: UserRepository;

  constructor() {
    this.userRepository = new UserRepository();
  }

  async createUser(name: string, email: string): Promise<User> {
    if (!name || !email) {
      throw new Error('Name and email are required');
    }

    if (!this.isValidEmail(email)) {
      throw new Error('Invalid email format');
    }

    return await this.userRepository.create(name, email);
  }

  async getAllUsers(): Promise<User[]> {
    return await this.userRepository.findAll();
  }

  async getUserById(id: number): Promise<User | null> {
    return await this.userRepository.findById(id);
  }

  async updateUser(id: number, name: string, email: string): Promise<User | null> {
    if (!name || !email) {
      throw new Error('Name and email are required');
    }

    if (!this.isValidEmail(email)) {
      throw new Error('Invalid email format');
    }

    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new Error('User not found');
    }

    return await this.userRepository.update(id, name, email);
  }

  async deleteUser(id: number): Promise<boolean> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new Error('User not found');
    }

    return await this.userRepository.delete(id);
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}