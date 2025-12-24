const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }
});

const UserModel = mongoose.model('User', userSchema);

class MongoDBUserRepository {
  async create(userRequest) {
    const user = new UserModel({
      name: userRequest.name,
      email: userRequest.email
    });

    const savedUser = await user.save();

    return {
      id: savedUser._id,
      name: savedUser.name,
      email: savedUser.email,
      createdAt: savedUser.createdAt
    };
  }

  async findAll() {
    const users = await UserModel.find();

    return users.map(user => ({
      id: user._id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt
    }));
  }

  async findById(id) {
    const user = await UserModel.findById(id);

    if (!user) return null;

    return {
      id: user._id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt
    };
  }
}

module.exports = { MongoDBUserRepository };