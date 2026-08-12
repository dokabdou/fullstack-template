import { Component, HostListener, signal, Inject, PLATFORM_ID, inject } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { ConfigService } from './core/services/config.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  styleUrls: ['./app.scss', '../styles.scss'],
})
export class App {
  protected readonly title = signal('frontend');

  readonly configService = inject(ConfigService);

  // button that allows you to scroll back to the top of the page without scrolling all the way up
  private readonly BUTTON_SIZE = 48;
  btnX = signal(0);
  btnY = signal(0);
  isDragging = signal(false);
  private dragStartX = 0;
  private dragStartY = 0;

  constructor(@Inject(PLATFORM_ID) private platformId: Object) {}

  ngOnInit() {
    if (isPlatformBrowser(this.platformId)) {
	  // start position at the bottom right
      this.btnX.set(window.innerWidth - this.BUTTON_SIZE - 20); // 20px margin
      this.btnY.set(window.innerHeight - this.BUTTON_SIZE - 20);
    }
  }

  private clampPosition(value: number, max: number): number {
    return Math.min(Math.max(value, 0), max - this.BUTTON_SIZE);
  }

  @HostListener('window:mousemove', ['$event'])
  onMouseMove(e: MouseEvent) {
    if (this.isDragging()) {
      e.preventDefault();
      let newX = e.clientX - this.dragStartX;
      let newY = e.clientY - this.dragStartY;
	  // prevent the button from going off the screen
      newX = this.clampPosition(newX, window.innerWidth);
      newY = this.clampPosition(newY, window.innerHeight);
      this.btnX.set(newX);
      this.btnY.set(newY);
    }
  }

  @HostListener('window:mouseup')
  onMouseUp() {
    this.isDragging.set(false);
    document.body.style.userSelect = '';
  }

  @HostListener('window:touchmove', ['$event'])
  onTouchMove(e: TouchEvent) {
    if (this.isDragging()) {
      const touch = e.touches[0];
      let newX = touch.clientX - this.dragStartX;
      let newY = touch.clientY - this.dragStartY;
      newX = this.clampPosition(newX, window.innerWidth);
      newY = this.clampPosition(newY, window.innerHeight);
      this.btnX.set(newX);
      this.btnY.set(newY);
    }
  }

  @HostListener('window:touchend')
  onTouchEnd() {
    this.isDragging.set(false);
    document.body.style.userSelect = '';
  }

  @HostListener('window:resize')
  onResize() {
    if (!isPlatformBrowser(this.platformId)) return;
    this.btnX.set(this.clampPosition(this.btnX(), window.innerWidth));
    this.btnY.set(this.clampPosition(this.btnY(), window.innerHeight));
  }

  startDrag(event: MouseEvent | TouchEvent) {
    event.preventDefault();
    const clientX = event instanceof MouseEvent ? event.clientX : event.touches[0].clientX;
    const clientY = event instanceof MouseEvent ? event.clientY : event.touches[0].clientY;

    this.dragStartX = clientX - this.btnX();
    this.dragStartY = clientY - this.btnY();
    this.isDragging.set(true);
    document.body.style.userSelect = 'none';
  }

  scrollToTop() {
    if (!this.isDragging()) {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }
}
