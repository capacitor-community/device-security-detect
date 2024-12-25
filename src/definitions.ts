/**
 * @file definitions.ts
 * @description TypeScript type definitions for the DeviceSecurityDetect plugin.
 */

/**
 * @interface DeviceSecurityDetectPlugin
 * @description Defines the methods provided by the DeviceSecurityDetect plugin.
 */
export interface DeviceSecurityDetectPlugin {
  /**
   * Detect if the device has been rooted (Android) or jailbroken (iOS).
   * 
   * This method provides a boolean value indicating whether the device
   * has been tampered with (e.g., by rooting or jailbreaking).
   * 
   * @returns A promise that resolves to an object containing:
   * - `value`: A boolean indicating if the device is rooted or jailbroken.
   * 
   * @example
   * ```typescript
   * const result = await DeviceSecurityDetect.isJailBreakOrRooted();
   * console.log(result.value); // true if rooted/jailbroken, false otherwise
   * ```
   * @since 6.0.0
   */
  isJailBreakOrRooted(): Promise<{ value: boolean }>;

  /**
   * Check if a PIN, password, or biometric authentication is enabled on the device.
   * 
   * This method checks whether the user has set up any kind of secure lock mechanism
   * (e.g., PIN, password, or biometric authentication) on their mobile device.
   * 
   * @returns A promise that resolves to an object containing:
   * - `value`: A boolean indicating if secure authentication is enabled.
   * 
   * @example
   * ```typescript
   * const result = await DeviceSecurityDetect.pinCheck();
   * console.log(result.value); // true if PIN/password is enabled, false otherwise
   * ```
   * @since 6.0.2
   */
  pinCheck(): Promise<{ value: boolean }>;
}
