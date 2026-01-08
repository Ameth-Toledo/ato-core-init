import { IUserRepository } from '../../domain/IUserRepository';
import { User } from '../../domain/entities/User';
import mongoose, { Schema, Document } from 'mongoose';

interface UserDocument extends Document {
  name: string;
  secondname: string | null;
  lastname: string;
  secondlastname: string | null;
  email: string;
  password: string;
  createdAt: Date;
}

const userSchema = new Schema<UserDocument>({
  name: { type: String, required: true },
  secondname: { type: String, default: null },
  lastname: { type: String, required: true },
  secondlastname: { type: String, default: null },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  createdAt: { type: Date, default: Date.now },
});

const UserModel = mongoose.model<UserDocument>('User', userSchema);

export class MongoDBUserRepository implements IUserRepository {
  async save(user: Omit<User, 'id' | 'createdAt'>): Promise<User> {
    const newUser = new UserModel({
      name: user.name,
      secondname: user.secondname,
      lastname: user.lastname,
      secondlastname: user.secondlastname,
      email: user.email,
      password: user.password,
    });

    const savedUser = await newUser.save();

    return {
      id: savedUser._id.toString() as any,
      name: savedUser.name,
      secondname: savedUser.secondname,
      lastname: savedUser.lastname,
      secondlastname: savedUser.secondlastname,
      email: savedUser.email,
      password: savedUser.password,
      createdAt: savedUser.createdAt,
    };
  }

  async getByEmail(email: string): Promise<User | null> {
    const user = await UserModel.findOne({ email });

    if (!user) return null;

    return {
      id: user._id.toString() as any,
      name: user.name,
      secondname: user.secondname,
      lastname: user.lastname,
      secondlastname: user.secondlastname,
      email: user.email,
      password: user.password,
      createdAt: user.createdAt,
    };
  }

  async getByID(id: number): Promise<User | null> {
    const user = await UserModel.findById(id);

    if (!user) return null;

    return {
      id: user._id.toString() as any,
      name: user.name,
      secondname: user.secondname,
      lastname: user.lastname,
      secondlastname: user.secondlastname,
      email: user.email,
      password: user.password,
      createdAt: user.createdAt,
    };
  }

  async getAll(): Promise<User[]> {
    const users = await UserModel.find().sort({ createdAt: -1 });

    return users.map(user => ({
      id: user._id.toString() as any,
      name: user.name,
      secondname: user.secondname,
      lastname: user.lastname,
      secondlastname: user.secondlastname,
      email: user.email,
      password: user.password,
      createdAt: user.createdAt,
    }));
  }

  async update(user: User): Promise<void> {
    const result = await UserModel.updateOne(
      { _id: user.id },
      {
        $set: {
          name: user.name,
          secondname: user.secondname,
          lastname: user.lastname,
          secondlastname: user.secondlastname,
          email: user.email,
          password: user.password,
        },
      }
    );

    if (result.matchedCount === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async delete(id: number): Promise<void> {
    const result = await UserModel.deleteOne({ _id: id });

    if (result.deletedCount === 0) {
      throw new Error('Usuario no encontrado');
    }
  }

  async getTotal(): Promise<number> {
    return await UserModel.countDocuments();
  }
}