import { Injectable, inject, Inject, signal, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable, tap, ReplaySubject } from 'rxjs';
import { LoginDTO, AuthDTO, RegistrationDTO } from '../../../models/auth.model';
import { AuthProvider } from '../providers/auth.provider';
import { DynamicInjectorService } from '../../services/dynamic-injector.service';
import { TokenService } from './token.service';
import { User } from '../../../models/user.model';
import { HttpClient } from '@angular/common/http';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly injector = inject(DynamicInjectorService);
  private readonly tokenService = inject(TokenService);
  private readonly router = inject(Router);
  private readonly http = inject(HttpClient);

  private readonly readySubject = new ReplaySubject<boolean>(1);
  public readonly ready$: Observable<boolean> = this.readySubject.asObservable();
  private initialized = false;

  // Use absolute URL so that calls from the browser always reach the backend
  private readonly API_BASE_URL = 'http://localhost:8080/auth';

  private currentUserSubject = new BehaviorSubject<User | null>(null);
  public currentUser$ = this.currentUserSubject.asObservable();

  readonly userFirstname = signal<string | null>(null);

  private readonly TEST_EXPIRATION_MS = 5 * 60 * 1000; // 5 minutes
  private countdownInterval: any = null;
  private expirationCheckInterval: any = null;
  private logoutTimer: any = null;

  private get provider(): AuthProvider {
    return this.injector.get(AuthProvider);
  }

  constructor(@Inject(PLATFORM_ID) private platformId: Object) {
    console.log('[AuthService] constructor – starting rehydrate');
    this.startExpirationCheck();
  }

  async init(): Promise<void> {
    if (isPlatformBrowser(this.platformId)) {
      this.rehydrate();
    }
    this.initialized = true;
    this.readySubject.next(true);
  }

  login(credentials: LoginDTO): Observable<AuthDTO> {
    return this.provider.login(credentials).pipe(
      tap((response) => {
        console.log('RESPONSE', response);
        this.tokenService.setToken(response.token);
        this.tokenService.setExpiration(response.expiresInMs);
        this.tokenService.setFirstname(response.firstname);
        this.userFirstname.set(response.firstname);
        this.scheduleLogout(response.expiresInMs);
      }),
    );
  }

  register(user: RegistrationDTO): Observable<void> {
    return this.provider.register(user);
  }

  /** Fetch the user profile (roles, etc.) – called after login */
  fetchUserProfile(): Observable<User> {
    // The endpoint is now absolute – no more parsing errors
    return this.http
      .get<User>(`${this.API_BASE_URL}/me`)
      .pipe(tap((user) => this.currentUserSubject.next(user)));
  }

  private startExpirationCheck(): void {
    this.expirationCheckInterval = setInterval(() => {
      if (this.tokenService.hasToken() && this.tokenService.isExpired()) {
        console.log('[AuthService] token expired – logging out');
        this.logout();
      }
    }, 30_000);
  }

  logout(): void {
    console.log('[AuthService] logout called');
    this.clearTimer();
    this.clearExpirationCheck();
    this.tokenService.removeToken();
    this.userFirstname.set(null);
    this.router.navigate(['/login']);
  }

  isAuthenticated(): boolean {
    return this.tokenService.hasToken();
  }

  getToken(): string | null {
    return this.tokenService.getToken();
  }

  private scheduleLogout(expiresInMs: number): void {
    this.clearTimer();
    const delay = expiresInMs - 5000;
    console.log('[AuthService] scheduling logout in', delay / 1000, 'seconds');
    this.logoutTimer = setTimeout(() => {
      console.log('[AuthService] scheduled logout timer fired');
      this.logout();
    }, delay);
    this.startCountdown(expiresInMs);
  }

  private startCountdown(totalMs: number): void {
    this.clearCountdown();
    let remaining = totalMs;
    const startTime = Date.now();
    this.countdownInterval = setInterval(() => {
      remaining = totalMs - (Date.now() - startTime);
      if (remaining <= 0) {
        this.logout();
      } else {
        console.log(`[AuthService] countdown: ${Math.round(remaining / 1000)} seconds remaining`);
      }
    }, 1000);
  }

  private clearCountdown(): void {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval);
      this.countdownInterval = null;
    }
  }

  private clearTimer(): void {
    if (this.logoutTimer) {
      clearTimeout(this.logoutTimer);
      this.logoutTimer = null;
    }
    this.clearCountdown();
  }

  /**
   * Restores session state from stored token without redirecting on failure.
   * If the token has expired, we just clean up – no navigation.
   */
  private rehydrate(): void {
    console.log('[AuthService] rehydrate – checking stored token');
    if (!this.tokenService.hasToken()) {
      return;
    }

    if (this.tokenService.isExpired()) {
      // Token expired while the app was closed – silently remove it
      this.tokenService.removeToken();
      this.userFirstname.set(null);
      return;
    }

    const firstname = this.tokenService.getFirstname();
    if (firstname) {
      this.userFirstname.set(firstname);
    }

    const expiresAt = this.tokenService.getExpiration();
    if (expiresAt) {
      const remaining = expiresAt - Date.now();
      if (remaining > 0) {
        this.scheduleLogout(remaining);
      } else {
        this.tokenService.removeToken();
        this.userFirstname.set(null);
      }
    }
  }

  private clearExpirationCheck(): void {
    if (this.expirationCheckInterval) {
      clearInterval(this.expirationCheckInterval);
      this.expirationCheckInterval = null;
    }
  }
}
