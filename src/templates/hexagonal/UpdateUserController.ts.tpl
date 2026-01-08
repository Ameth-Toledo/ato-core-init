import { Request, Response } from 'express';
import { UpdateUserUseCase } from '../../application/UpdateUserUseCase';
import { UpdateUserRequest } from '../../domain/dto/UserRequest';

export class UpdateUserController {
  constructor(private updateUserUseCase: UpdateUserUseCase) {}

  async execute(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      if (isNaN(id)) {
        res.status(400).json({ error: 'ID invalido' });
        return;
      }

      const updateRequest: UpdateUserRequest = req.body;

      if (!updateRequest.name || !updateRequest.lastname || !updateRequest.email) {
        res.status(400).json({ error: 'Campos obligatorios: name, lastname, email' });
        return;
      }

      const user = await this.updateUserUseCase.execute(id, updateRequest);

      res.status(200).json({ message: 'Usuario actualizado exitosamente' });
    } catch (error) {
      if (error instanceof Error) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }
}