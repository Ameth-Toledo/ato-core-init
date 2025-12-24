class GetAllUsersController {
  constructor(getAllUsersUseCase) {
    this.getAllUsersUseCase = getAllUsersUseCase;
  }

  async handle(req, res) {
    try {
      const users = await this.getAllUsersUseCase.execute();

      res.status(200).json(users);
    } catch (error) {
      console.error('Error getting users:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}

module.exports = { GetAllUsersController };