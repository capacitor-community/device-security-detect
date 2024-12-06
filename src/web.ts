import { WebPlugin } from '@capacitor/core';

import type { DeviceSecurityDetectPlugin } from './definitions';

export class DeviceSecurityDetectWeb extends WebPlugin implements DeviceSecurityDetectPlugin {
  async isJailBreakOrRooted(): Promise<{ value: boolean; }> {
      throw new Error("Not supported on the web")
  }
}