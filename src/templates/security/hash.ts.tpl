import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

export async function hashPassword(password: string): Promise<string> {
  const hash = await bcrypt.hash(password, SALT_ROUNDS);
  return hash;
}

export async function checkPassword(hash: string, password: string): Promise<boolean> {
  const isValid = await bcrypt.compare(password, hash);
  return isValid;
}