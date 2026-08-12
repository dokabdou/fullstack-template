import { DynamicService } from '../../services/dynamic-injector.service';
import { Observable } from 'rxjs';
import { LoginDTO, AuthDTO, RegistrationDTO } from '../../../models/auth.model';

export abstract class AuthProvider implements DynamicService {
  abstract injectable(): boolean;
  abstract login(credentials: LoginDTO): Observable<AuthDTO>;
  abstract register(user: RegistrationDTO): Observable<void>;
}
