import crypto from 'crypto';

export function generateRandomString(length: number): string {
  const bytes = Math.ceil(length / 2);
  const buffer = crypto.randomBytes(bytes);
  return buffer.toString('hex').slice(0, length);
}

export function trimString(str: string): string {
  return str.trim();
}

export function sanitizeEmail(email: string): string {
  return email.toLowerCase().trim();
}

export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}