import { Request, Response } from 'express';
import { UserService } from '../services/UserService';
import { generateJWT, generateRefreshToken, setAuthCookie, setRefreshCookie, clearAuthCookies, validateRefreshToken } from '../core/security/auth';

export class UserController {
  private userService: UserService;

  constructor() {
    this.userService = new UserService();
  }

  async register(req: Request, res: Response): Promise<void> {
    try {
      const { name, secondname, lastname, secondlastname, email, password } = req.body;

      if (!name || !lastname || !email || !password) {
        res.status(400).json({ error: 'Campos obligatorios: name, lastname, email, password' });
        return;
      }

      const user = await this.userService.register({
        name,
        secondname,
        lastname,
        secondlastname,
        email,
        password,
      });

      res.status(201).json({
        message: 'Usuario registrado exitosamente',
        user: {
          id: user.id,
          name: user.name,
          secondname: user.secondname,
          lastname: user.lastname,
          secondlastname: user.secondlastname,
          email: user.email,
          created_at: user.created_at,
        },
      });
    } catch (error) {
      if (error instanceof Error) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }

  async login(req: Request, res: Response): Promise<void> {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        res.status(400).json({ error: 'Email y password son requeridos' });
        return;
      }

      const user = await this.userService.login(email, password);

      const accessToken = generateJWT(user.id, user.email, 1);
      const refreshToken = generateRefreshToken(user.id);

      setAuthCookie(res, accessToken);
      setRefreshCookie(res, refreshToken);

      res.status(200).json({
        message: 'Login exitoso',
        user: {
          id: user.id,
          name: user.name,
          secondname: user.secondname,
          lastname: user.lastname,
          secondlastname: user.secondlastname,
          email: user.email,
          created_at: user.created_at,
        },
      });
    } catch (error) {
      if (error instanceof Error) {
        res.status(401).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }

  async logout(req: Request, res: Response): Promise<void> {
    clearAuthCookies(res);
    res.status(200).json({ message: 'Logout exitoso' });
  }

  async refreshToken(req: Request, res: Response): Promise<void> {
    try {
      const refreshToken = req.cookies?.refresh_token;

      if (!refreshToken) {
        res.status(401).json({ error: 'Refresh token no encontrado' });
        return;
      }

      const claims = validateRefreshToken(refreshToken);

      if (!claims) {
        res.status(401).json({ error: 'Refresh token invalido' });
        return;
      }

      const user = await this.userService.getUserById(claims.userId);

      const newAccessToken = generateJWT(user.id, user.email, 1);

      setAuthCookie(res, newAccessToken);
      res.status(200).json({ message: 'Token renovado' });
    } catch (error) {
      res.status(401).json({ error: 'Error al renovar token' });
    }
  }

  async getProfile(req: Request, res: Response): Promise<void> {
    try {
      if (!req.userId) {
        res.status(401).json({ error: 'No autenticado' });
        return;
      }

      const user = await this.userService.getUserById(req.userId);

      res.status(200).json({
        user: {
          id: user.id,
          name: user.name,
          secondname: user.secondname,
          lastname: user.lastname,
          secondlastname: user.secondlastname,
          email: user.email,
          created_at: user.created_at,
        },
      });
    } catch (error) {
      res.status(404).json({ error: 'Usuario no encontrado' });
    }
  }

  async verifyToken(req: Request, res: Response): Promise<void> {
    res.status(200).json({
      authenticated: true,
      user: {
        id: req.userId,
        email: req.email,
        roleId: req.roleId,
      },
    });
  }

  async getAll(req: Request, res: Response): Promise<void> {
    try {
      const users = await this.userService.getAllUsers();

      const usersResponse = users.map(user => ({
        id: user.id,
        name: user.name,
        secondname: user.secondname,
        lastname: user.lastname,
        secondlastname: user.secondlastname,
        email: user.email,
        created_at: user.created_at,
      }));

      res.status(200).json({ users: usersResponse });
    } catch (error) {
      res.status(500).json({ error: 'Error interno del servidor' });
    }
  }

  async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      if (isNaN(id)) {
        res.status(400).json({ error: 'ID invalido' });
        return;
      }

      const user = await this.userService.getUserById(id);

      res.status(200).json({
        user: {
          id: user.id,
          name: user.name,
          secondname: user.secondname,
          lastname: user.lastname,
          secondlastname: user.secondlastname,
          email: user.email,
          created_at: user.created_at,
        },
      });
    } catch (error) {
      if (error instanceof Error) {
        res.status(404).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }

  async update(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      if (isNaN(id)) {
        res.status(400).json({ error: 'ID invalido' });
        return;
      }

      const { name, secondname, lastname, secondlastname, email } = req.body;

      if (!name || !lastname || !email) {
        res.status(400).json({ error: 'Campos obligatorios: name, lastname, email' });
        return;
      }

      await this.userService.updateUser(id, {
        name,
        secondname,
        lastname,
        secondlastname,
        email,
      });

      res.status(200).json({ message: 'Usuario actualizado exitosamente' });
    } catch (error) {
      if (error instanceof Error) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }

  async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);

      if (isNaN(id)) {
        res.status(400).json({ error: 'ID invalido' });
        return;
      }

      await this.userService.deleteUser(id);

      res.status(200).json({ message: 'Usuario eliminado exitosamente' });
    } catch (error) {
      if (error instanceof Error) {
        res.status(400).json({ error: error.message });
      } else {
        res.status(500).json({ error: 'Error interno del servidor' });
      }
    }
  }
}