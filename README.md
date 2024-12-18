<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">Device Security Detect Plugin</h3>
<p align="center"><strong><code>@capacitor-community/device-security-detect</code></strong></p>
<p align="center">
  The Device Security Detect plugin is designed to provide comprehensive device security detection capabilities for Capacitor-based applications. It aims to detect the device has been rooted (Android) or jailbroken (iOS). By using this plugin, developers can enhance the security of their applications and take appropriate actions based on the detected security status.
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

```bash
npm install @capacitor-community/device-security-detect
npx cap sync
```

## API

<docgen-index>

* [`isJailBreakOrRooted()`](#isjailbreakorrooted)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### isJailBreakOrRooted()

```typescript
isJailBreakOrRooted() => Promise<{ value: boolean; }>
```

Detect if the device has been rooted (Android) or jailbroken (iOS)

**Returns:** <code>Promise&lt;{ value: boolean; }&gt;</code>

**Since:** 6.0.0

--------------------

</docgen-api>

## Usage

### Detect if the device has been rooted (Android) or jailbroken (iOS)

```
import { DeviceSecurityDetect } from '@capacitor-community/device-security-detect';

const { value } = await DeviceSecurityDetect.isJailBreakOrRooted();
```
