import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class TokenService {
	// {PROJECT_NAME}-
	private tokenKey = 'frontend_auth_token';
	private expiresKey = 'frontend_token_expires';
	private firstnameKey = 'frontend_user_firstname';

	setToken(token: string): void {
		if (typeof localStorage !== 'undefined') {
			localStorage.setItem(this.tokenKey, token);
		}
	}

	getToken(): string | null {
		if (typeof localStorage !== 'undefined') {
			return localStorage.getItem(this.tokenKey);
		}
		return null;
	}

	removeToken(): void {
		if (typeof localStorage !== 'undefined') {
			localStorage.removeItem(this.tokenKey);
			localStorage.removeItem(this.expiresKey);
			localStorage.removeItem(this.firstnameKey);
		}
	}

	setExpiration(expiresInMs: number): void {
		if (typeof localStorage !== 'undefined') {
			const expiresAt = Date.now() + expiresInMs;
			localStorage.setItem(this.expiresKey, expiresAt.toString());
		}
	}

	getExpiration(): number | null {
		if (typeof localStorage !== 'undefined') {
			const val = localStorage.getItem(this.expiresKey);
			return val ? Number(val) : null;
		}
		return null;
	}

	isExpired(): boolean {
		const expires = this.getExpiration();
		return expires !== null && Date.now() > expires;
	}

	setFirstname(firstname: string): void {
		if (typeof localStorage !== 'undefined') {
			localStorage.setItem(this.firstnameKey, firstname);
		}
	}

	getFirstname(): string | null {
		if (typeof localStorage !== 'undefined') {
			return localStorage.getItem(this.firstnameKey);
		}
		return null;
	}

	hasToken(): boolean {
		return !!this.getToken() && !this.isExpired();
	}
}
