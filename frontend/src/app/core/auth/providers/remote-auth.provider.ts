import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthProvider } from './auth.provider';
import { LoginDTO, AuthDTO, RegistrationDTO } from '../../../models/auth.model';
import { ConfigService } from '../../services/config.service';

@Injectable()
export class RemoteAuthProvider extends AuthProvider {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = 'http://localhost:8080/auth';
  private readonly configService = inject(ConfigService);

  injectable(): boolean {
    // return this.configService.isDemoMode();
    return true;
  }

  login(credentials: LoginDTO): Observable<AuthDTO> {
    return this.http.post<AuthDTO>(`${this.apiUrl}/login`, credentials);
  }

  register(user: RegistrationDTO): Observable<void> {
    return this.http.post<void>(`${this.apiUrl}/register`, user);
  }
}
