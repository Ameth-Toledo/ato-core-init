class CreateUserUseCase {
  constructor(userRepository) {
    this.userRepository = userRepository;
  }

  async execute(userRequest) {
    const user = await this.userRepository.create(userRequest);

    return {
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt.toISOString()
    };
  }
}

module.exports = { CreateUserUseCase };