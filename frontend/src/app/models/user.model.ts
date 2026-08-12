export interface User {
  id: string;
  email: string;
  firstname: string;
  lastname: string;
  roles: string[]; // e.g. ['USER', 'ADMIN']
}
