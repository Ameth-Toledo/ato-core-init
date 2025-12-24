import { IUserRepository } from '../../domain/IUserRepository';
import { User } from '../../domain/entities/User';
import { UserRequest } from '../../domain/dto/UserRequest';
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  createdAt: { type: Date, default: Date.now }
});

const UserModel = mongoose.model('User', userSchema);

export class MongoDBUserRepository implements IUserRepository {
  async create(userRequest: UserRequest): Promise<User> {
    const user = new UserModel({
      name: userRequest.name,
      email: userRequest.email
    });

    const savedUser = await user.save();

    return {
      id: savedUser._id as any,
      name: savedUser.name,
      email: savedUser.email,
      createdAt: savedUser.createdAt
    };
  }

  async findAll(): Promise<User[]> {
    const users = await UserModel.find();

    return users.map(user => ({
      id: user._id as any,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt
    }));
  }

  async findById(id: number): Promise<User | null> {
    const user = await UserModel.findById(id);

    if (!user) return null;

    return {
      id: user._id as any,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt
    };
  }
}