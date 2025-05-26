import { Component } from '@angular/core';
import {
  IonHeader, IonButton, IonToolbar, IonTitle, IonContent, IonButtons,
} from '@ionic/angular/standalone';

// NATIVE
import { DeviceSecurityDetect } from '@capacitor-community/device-security-detect';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [
    IonButton, IonHeader, IonToolbar, IonTitle, IonContent, IonButtons
  ]
})
export class HomePage {

  constructor() { }

  public async checkRootStatus(): Promise<void> {
    const { value } = await DeviceSecurityDetect.isJailBreakOrRooted();
    if (value) {
      console.warn('The device is rooted or jailbroken!');
    } else {
      console.log('The device is secure.');
    }
  }

  public async checkPinStatus(): Promise<void> {
    const { value } = await DeviceSecurityDetect.pinCheck();
    if (value) {
      console.log('A secure lock mechanism is enabled on the device.');
    } else {
      console.warn('No secure lock mechanism is detected.');
    }
  }
}
