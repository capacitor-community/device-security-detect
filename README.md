<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Device Security Detect Plugin</h3>
<p align="center"><strong><code>@capacitor-community/device-security-detect</code></strong></p>
<p align="center">
The Device Security Detect plugin offers advanced device security detection features for Capacitor-based applications. It enables developers to determine whether a device has been rooted (Android) or jailbroken (iOS), providing a crucial layer of security assessment. By integrating this plugin, developers can proactively safeguard their applications, mitigate risks, and implement tailored responses based on the device's security status.
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2024?style=flat-square" />
  <a href="https://github.com/capacitor-community/example/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/capacitor-community/example/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/example"><img src="https://img.shields.io/npm/l/@capacitor-community/example?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/example"><img src="https://img.shields.io/npm/dw/@capacitor-community/example?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/example"><img src="https://img.shields.io/npm/v/@capacitor-community/example?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-0-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Table of Contents

- [Maintainers](#maintainers)
- [Plugin versions](#plugin-versions)
- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
- [API](#api)
- [Usage](#usage)

## Maintainers

| Maintainer | GitHub                              | Active |
| ---------- | -------------------------------     | ------ |
| 4ooper     | [4ooper](https://github.com/4ooper) | yes    |
| ryaa       | [ryaa](https://github.com/ryaa)     | yes    |

## Plugin versions

| Capacitor version | Plugin version |
| ----------------- | -------------- |
| 6.x               | 6.x            |

## Supported Platforms

- iOS
- Android

## Installation

Using npm:

```bash
npm install @capacitor-community/device-security-detect
```

Using yarn:

```bash
yarn add @capacitor-community/device-security-detect
```

Sync native files:

```bash
npx cap sync
```

## API

<docgen-index>

* [`isJailBreakOrRooted()`](#isjailbreakorrooted)
* [`pinCheck()`](#pincheck)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### isJailBreakOrRooted()

```typescript
isJailBreakOrRooted() => Promise<{ value: boolean; }>
```

Detect if the device has been rooted (Android) or jailbroken (iOS).

This method provides a boolean value indicating whether the device
has been tampered with (e.g., by rooting or jailbreaking).

**Returns:** <code>Promise&lt;{ value: boolean; }&gt;</code>

**Since:** 6.0.0

--------------------


### pinCheck()

```typescript
pinCheck() => Promise<{ value: boolean; }>
```

Check if a PIN, password, or biometric authentication is enabled on the device.

This method checks whether the user has set up any kind of secure lock mechanism
(e.g., PIN, password, or biometric authentication) on their mobile device.

**Returns:** <code>Promise&lt;{ value: boolean; }&gt;</code>

**Since:** 6.0.2

--------------------

</docgen-api>

## Usage

### Detect if the device has been rooted (Android) or jailbroken (iOS)

```typescript
import { DeviceSecurityDetect } from '@capacitor-community/device-security-detect';

async function checkRootStatus() {
  const { value } = await DeviceSecurityDetect.isJailBreakOrRooted();
  if (value) {
    console.warn('The device is rooted or jailbroken!');
  } else {
    console.log('The device is secure.');
  }
}
```

### Check if a PIN, password, or biometric authentication is enabled on the device

```typescript
import { DeviceSecurityDetect } from '@capacitor-community/device-security-detect';

async function checkPinStatus() {
  const { value } = await DeviceSecurityDetect.pinCheck();
  if (value) {
    console.log('A secure lock mechanism is enabled on the device.');
  } else {
    console.warn('No secure lock mechanism is detected.');
  }
}
```

### Full Example

```typescript
import { DeviceSecurityDetect } from '@capacitor-community/device-security-detect';

async function checkDeviceSecurity() {
  try {
    const rootStatus = await DeviceSecurityDetect.isJailBreakOrRooted();
    console.log(`Root/Jailbreak status: ${rootStatus.value ? 'Yes' : 'No'}`);
    
    const pinStatus = await DeviceSecurityDetect.pinCheck();
    console.log(`Secure lock enabled: ${pinStatus.value ? 'Yes' : 'No'}`);
  } catch (error) {
    console.error('Error checking device security:', error);
  }
}

checkDeviceSecurity();
```

Use this plugin to enhance your application's security and respond appropriately to potential risks.
```