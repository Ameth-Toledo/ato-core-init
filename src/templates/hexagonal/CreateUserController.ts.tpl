import { Request, Response } from 'express';
import { CreateUserUseCase } from '../../application/CreateUserUseCase';

export class CreateUserController {
  constructor(private createUserUseCase: CreateUserUseCase) {}

  async handle(req: Request, res: Response): Promise<void> {
    try {
      const { name, email } = req.body;

      if (!name || !email) {
        res.status(400).json({ error: 'Name and email are required' });
        return;
      }

      const user = await this.createUserUseCase.execute({ name, email });

      res.status(201).json(user);
    } catch (error) {
      console.error('Error creating user:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}