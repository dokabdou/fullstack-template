import { Component, inject } from '@angular/core';
import { AuthService } from '../../core/auth/services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [],
  templateUrl: './sidebar.html',
  styleUrls: ['./sidebar.scss'],
})
export class Sidebar {
  private auth = inject(AuthService);
  sidebarOpen = true;

  constructor(private router: Router) {}

  get firstname(): string {
    return this.auth.userFirstname() ?? '';
  }

  isActive(path: string): boolean {
    return this.router.url.startsWith(path);
  }

  goToHome() {
    this.router.navigate(['/home']);
  }

  toggleSidebar() {
    this.sidebarOpen = !this.sidebarOpen;
  }

  onLogout(): void {
    this.auth.logout(); // clears token, redirects to /login
  }
}
