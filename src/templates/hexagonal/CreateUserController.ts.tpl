import { Request, Response } from 'express';
import { CreateUserUseCase } from '../../application/CreateUserUseCase';
import { UserRequest } from '../../domain/dto/UserRequest';
import { UserResponse } from '../../domain/dto/UserResponse';

export class CreateUserController {
  constructor(private createUserUseCase: CreateUserUseCase) {}

  async execute(req: Request, res: Response): Promise<void> {
    try {
      const userRequest: UserRequest = req.body;

      if (!userRequest.name || !userRequest.lastname || !userRequest.email || !userRequest.password) {
        res.status(400).json({ error: 'Campos obligatorios: name, lastname, email, password' });
        return;
      }

      const user = await this.createUserUseCase.execute(userRequest);

      const userResponse: UserResponse = {
        id: user.id,
        name: user.name,
        secondname: user.secondname,
        lastname: user.lastname,
        secondlastname: user.secondlastname,
        email: user.email,
        createdAt: user.createdAt.toISOString(),
      };

      res.status(201).json({
        message: 'Usuario creado exitosamente',
        user: userResponse,
      });
    } catch (error) {
      if (error instanceof Error) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }
}