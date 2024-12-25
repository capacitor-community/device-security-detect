/**
 * @file index.ts
 * @description Entry point for the DeviceSecurityDetect plugin. 
 * This file defines the plugin's registration and export mechanisms.
 */

import { registerPlugin } from '@capacitor/core';
import type { DeviceSecurityDetectPlugin } from './definitions';

/**
 * Registers the `DeviceSecurityDetect` plugin.
 * 
 * - The plugin name `DeviceSecurityDetect` is used to bridge native code with JavaScript.
 * - The web implementation is dynamically imported to optimize load times and performance for web environments.
 */
const DeviceSecurityDetect = registerPlugin<DeviceSecurityDetectPlugin>('DeviceSecurityDetect', {
  /**
   * Dynamic import of the web implementation.
   * This is used only when running in a web environment.
   * 
   * @returns A promise that resolves to an instance of the `DeviceSecurityDetectWeb` class.
   */
  web: () => import('./web').then((m) => new m.DeviceSecurityDetectWeb()),
});

/**
 * Re-export the plugin type definitions for developer convenience.
 * This allows TypeScript users to access the `DeviceSecurityDetectPlugin` type.
 */
export * from './definitions';

/**
 * Exports the registered plugin as the default export.
 * Users can import and use `DeviceSecurityDetect` in their projects to call the plugin's methods.
 */
export { DeviceSecurityDetect };
