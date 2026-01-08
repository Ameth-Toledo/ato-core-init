import { Request, Response } from 'express';
import { GetUserByIdUseCase } from '../../application/GetUserByIdUseCase';
import { UserResponse } from '../../domain/dto/UserResponse';

export class GetUserByIdController {
  constructor(private getUserByIdUseCase: GetUserByIdUseCase) {}

  async execute(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      if (isNaN(id)) {
        res.status(400).json({ error: 'ID invalido' });
        return;
      }

      const user = await this.getUserByIdUseCase.execute(id);

      const userResponse: UserResponse = {
        id: user.id,
        name: user.name,
        secondname: user.secondname,
        lastname: user.lastname,
        secondlastname: user.secondlastname,
        email: user.email,
        createdAt: user.createdAt.toISOString(),
      };

      res.status(200).json({ user: userResponse });
    } catch (error) {
      if (error instanceof Error) {
        res.status(404).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }
}