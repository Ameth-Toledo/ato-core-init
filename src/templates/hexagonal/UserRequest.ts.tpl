export interface UserRequest {
  name: string;
  secondname?: string;
  lastname: string;
  secondlastname?: string;
  email: string;
  password: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface UpdateUserRequest {
  name: string;
  secondname?: string;
  lastname: string;
  secondlastname?: string;
  email: string;
}