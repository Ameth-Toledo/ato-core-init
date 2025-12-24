const { UserService } = require('../services/UserService');

class UserController {
  constructor() {
    this.userService = new UserService();
  }

  async create(req, res) {
    try {
      const { name, email } = req.body;
      const user = await this.userService.createUser(name, email);
      res.status(201).json(user);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  }

  async getAll(req, res) {
    try {
      const users = await this.userService.getAllUsers();
      res.status(200).json(users);
    } catch (error) {
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  async getById(req, res) {
    try {
      const id = parseInt(req.params.id);
      const user = await this.userService.getUserById(id);

      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }

      res.status(200).json(user);
    } catch (error) {
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  async update(req, res) {
    try {
      const id = parseInt(req.params.id);
      const { name, email } = req.body;
      const user = await this.userService.updateUser(id, name, email);

      res.status(200).json(user);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  }

  async delete(req, res) {
    try {
      const id = parseInt(req.params.id);
      await this.userService.deleteUser(id);

      res.status(204).send();
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  }
}

module.exports = { UserController };