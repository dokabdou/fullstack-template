import { Injectable, inject, PLATFORM_ID } from '@angular/core';
import { CanActivate, Router, UrlTree } from '@angular/router';
import { isPlatformServer } from '@angular/common';
import { AuthService } from '../auth/services/auth.service';
import { TokenService } from '../auth/services/token.service';
import { map, take } from 'rxjs/operators';
import { Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  private auth = inject(AuthService);
  private token = inject(TokenService);
  private router = inject(Router);
  private platformId = inject(PLATFORM_ID);

  canActivate(): boolean | UrlTree {
    if (isPlatformServer(this.platformId)) {
      return true;
    }

    if (!this.auth.isAuthenticated()) {
      return this.router.createUrlTree(['/login']);
    }
    if (this.token.isExpired()) {
      this.token.removeToken();
      this.auth.userFirstname.set(null);
      return this.router.createUrlTree(['/login']);
    }
    return true;
  }
}
