export interface LoginDTO {
  email: string;
  password: string;
}

export interface AuthDTO {
  token: string;
  type: string;
  expiresInMs: number;
  firstname: string;
}

export interface RegistrationDTO {
  firstname: string;
  lastname: string;
  birthdate: string;
  email: string;
  password: string;
  createdAt: string;
  updatedAt: string;
  rolesIds: string[];
}
