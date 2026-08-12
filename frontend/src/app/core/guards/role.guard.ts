import { Injectable } from '@angular/core';
import { CanActivate, ActivatedRouteSnapshot, Router, UrlTree } from '@angular/router';
import { AuthService } from '../auth/services/auth.service';
import { map, Observable } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class RoleGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router,
  ) {}

  canActivate(route: ActivatedRouteSnapshot): Observable<boolean | UrlTree> {
    const expectedRoles = route.data['roles'] as string[]; // e.g. ['USER']
    return this.authService.currentUser$.pipe(
      map((user) => {
        if (!user || !user.roles) {
          return this.router.createUrlTree(['/login']);
        }
        const hasRole = expectedRoles.some((role) => user.roles.includes(role));
        return hasRole ? true : this.router.createUrlTree(['/unauthorized']);
      }),
    );
  }
}
