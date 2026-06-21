/* 
// TO DO :: SET UP
import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { tap } from 'rxjs/operators';

export const adminGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router); */

  /* if (authService.isLoggedIn() && authService.isAdmin()) {
    return true;
  }

  console.warn('Admin Guard : Access Blocked');
  router.navigate(['/']); // return to home page
  return false; */

/*   return authService.verifyAdminStatus().pipe(
    tap((isReallyAdmin) => {
      if (!isReallyAdmin) {
        console.warn('SECURITY ALERT: Fake Admin detected or session expired!');
        router.navigate(['/']);
      }
    }),
  );
};
 */