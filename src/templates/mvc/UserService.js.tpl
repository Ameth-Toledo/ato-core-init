const { UserRepository } = require('../repositories/UserRepository');

class UserService {
  constructor() {
    this.userRepository = new UserRepository();
  }

  async createUser(name, email) {
    if (!name || !email) {
      throw new Error('Name and email are required');
    }

    if (!this.isValidEmail(email)) {
      throw new Error('Invalid email format');
    }

    return await this.userRepository.create(name, email);
  }

  async getAllUsers() {
    return await this.userRepository.findAll();
  }

  async getUserById(id) {
    return await this.userRepository.findById(id);
  }

  async updateUser(id, name, email) {
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

  async deleteUser(id) {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new Error('User not found');
    }

    return await this.userRepository.delete(id);
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }
}

module.exports = { UserService };