export interface UserResponse {
  id: number;
  name: string;
  secondname: string | null;
  lastname: string;
  secondlastname: string | null;
  email: string;
  createdAt: string;
}

export interface LoginResponse {
  message: string;
  user: UserResponse;
}