import { Injectable, signal, effect } from '@angular/core';

const STORAGE_KEY = 'demoMode';

@Injectable({ providedIn: 'root' })
export class ConfigService {
  readonly isDemoMode = signal(this.readInitialValue());

  constructor() {
    effect(() => {
      // Only persist in browser environments
      if (typeof localStorage !== 'undefined') {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(this.isDemoMode()));
      }
    });
  }

  toggleDemoMode(): void {
    this.isDemoMode.update((v) => !v);
    window.location.reload();
  }

  private readInitialValue(): boolean {
    // Safely read only if localStorage exists
    if (typeof localStorage !== 'undefined') {
      const stored = localStorage.getItem(STORAGE_KEY);
      return stored !== null ? JSON.parse(stored) : true;
    }
    return true; // default for SSR / non-browser
  }
}
