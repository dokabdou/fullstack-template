import { Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../auth/services/auth.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [FormsModule, CommonModule, RouterLink],
  templateUrl: './register.html',
  styleUrls: ['./register.scss'],
})
export class Register {
  private auth = inject(AuthService);
  private router = inject(Router);

  firstname = '';
  lastname = '';
  birthdate = new Date().toISOString().split('T')[0];
  email = '';
  password = '';
  confirmPassword = '';
  createdAt = new Date().toISOString();
  updatedAt = new Date().toISOString();
  isLoading = false;
  errorMessage = '';


  onSubmit() {
    // Basic field validation
    if (!this.firstname || !this.lastname || !this.birthdate || !this.email || !this.password) {
      this.errorMessage = 'Tous les champs sont obligatoires.';
      return;
    }

    // 🆕 Password confirmation
    if (this.password !== this.confirmPassword) {
      this.errorMessage = 'Les mots de passe ne correspondent pas.';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    this.auth
      .register({
        firstname: this.firstname,
        lastname: this.lastname,
        birthdate: this.birthdate,
        email: this.email,
        password: this.password,
		createdAt: this.createdAt,
		updatedAt: this.updatedAt,
        rolesIds: [''],
      })
      .subscribe({
        next: () => {
          this.isLoading = false;
          this.router.navigate(['/login']);
        },
        error: (err) => {
          this.isLoading = false;
          if (err.status === 409) {
            this.errorMessage = 'Cet email est déjà utilisé.';
          } else {
            this.errorMessage = "Erreur lors de l'inscription.";
          }
        },
      });
  }
}
