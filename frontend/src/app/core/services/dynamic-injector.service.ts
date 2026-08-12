import { AbstractType, inject, Injectable, InjectionToken, Injector, Type } from '@angular/core';

export interface DynamicService {
  injectable(): boolean;
}

@Injectable({ providedIn: 'root' })
export class DynamicInjectorService {
  private readonly injector = inject(Injector);

  get<T extends DynamicService>(token: Type<any> | InjectionToken<any> | AbstractType<any>): T {
    const services = this.injector.get(token, []) as T[];
    const match = services.find((s) => s.injectable());
    if (!match) {
      throw new Error(`No provider found for: ${token}`);
    }
    return match;
  }
}
