import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-home-page',
  imports: [],
  templateUrl: './home-page.html',
  styleUrl: './home-page.scss',
})
export class HomePage implements OnInit {
  constructor(private router: Router) {}

  ngOnInit(): void {}

  isActive(path: string): boolean {
    return this.router.url.startsWith(path);
  }

  goToLogin() {
    this.router.navigate(['/login']);
  }
}
