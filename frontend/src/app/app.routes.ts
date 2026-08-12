import { Routes } from '@angular/router';
import { Shell } from './layout/shell/shell';
import { AuthGuard } from './core/guards/auth.guard';
import { Login } from './core/login/login';
import { Register } from './core/register/register';
import { HomePage } from './core/home-page/home-page';

export const routes: Routes = [
  // Public pages – full screen
  { path: 'login', component: Login },
  { path: 'register', component: Register },

  // Protected area
  {
    path: '',
    component: Shell,
    canActivate: [AuthGuard],
    children: [
      { path: '', redirectTo: 'home', pathMatch: 'full' },
      { path: 'home', component: HomePage },
    ],
  },

  // Wildcard → login (still full page)
  { path: '**', redirectTo: '/login' },
];
