/* 
TO DO :: SET UP
import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { AuthService } from './services/auth.service';
import { catchError } from 'rxjs/operators';
import { throwError } from 'rxjs';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const authService = inject(AuthService);

  req = req.clone({
    withCredentials: true,
  });

  return next(req).pipe(
    catchError((error: HttpErrorResponse) => {
      // If Java says "Unauthorized" (401) or "Forbidden" (403)

      if (req.url.includes('/login') || req.url.includes('/register')) {
        // wrong email/password errors
        return throwError(() => error);
      }

      if (error.status === 401 || error.status === 403) {
        console.warn('Security Token Expired or Invalid! Auto-logging out...');

        authService.logout();

        if (typeof window !== 'undefined') {
          setTimeout(() => {
            window.location.reload();
          }, 500);
        }
      }
      return throwError(() => error);
    }),
  );
};
 */