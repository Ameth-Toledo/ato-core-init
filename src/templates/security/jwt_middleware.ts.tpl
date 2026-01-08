import { Request, Response, NextFunction } from 'express';
import { validateJWT } from './auth';

declare global {
  namespace Express {
    interface Request {
      userId?: number;
      email?: string;
      roleId?: number;
    }
  }
}

export function jwtMiddleware(req: Request, res: Response, next: NextFunction): void {
  const token = req.cookies?.access_token;

  if (!token) {
    res.status(401).json({ error: 'No autenticado - token no encontrado' });
    return;
  }

  const claims = validateJWT(token);

  if (!claims) {
    res.status(401).json({ error: 'Token invalido o expirado' });
    return;
  }

  req.userId = claims.userId;
  req.email = claims.email;
  req.roleId = claims.roleId;

  next();
}

export function requireRole(requiredRoleId: number) {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.roleId) {
      res.status(403).json({ error: 'Rol no encontrado en el token' });
      return;
    }

    if (req.roleId !== requiredRoleId) {
      res.status(403).json({ error: 'No tienes permisos para acceder a este recurso' });
      return;
    }

    next();
  };
}

export function requireAnyRole(...allowedRoleIds: number[]) {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.roleId) {
      res.status(403).json({ error: 'Rol no encontrado en el token' });
      return;
    }

    if (!allowedRoleIds.includes(req.roleId)) {
      res.status(403).json({ error: 'No tienes permisos para acceder a este recurso' });
      return;
    }

    next();
  };
}

export function optionalJWT(req: Request, res: Response, next: NextFunction): void {
  const token = req.cookies?.access_token;

  if (!token) {
    next();
    return;
  }

  const claims = validateJWT(token);

  if (claims) {
    req.userId = claims.userId;
    req.email = claims.email;
    req.roleId = claims.roleId;
  }

  next();
}