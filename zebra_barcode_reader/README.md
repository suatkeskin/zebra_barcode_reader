# Zebra RFID Reader plugin

<?code-excerpt path-base="example/lib"?>

The Unified Zebra RFID library for Android library that adds a comprehensive set of APIs to easily
create powerful applications for Zebra RFID Handheld readers and Fixed readers.
RFID SDK for Android includes class library, sample apps and source code to enable developers to
easily build apps that take full advantage of the power of Zebra devices.
Wraps platform-specific persistent storage for simple data
(NSUserDefaults on iOS and macOS, SharedPreferences on Android, etc.).
Data may be persisted to disk asynchronously,
and there is no guarantee that writes will be persisted to disk after
returning, so this plugin must not be used for storing critical data.

|             | Android |
|-------------|---------|
| **Support** | SDK 27+ |

## Supported Devices

<?code-excerpt "readme_excerpts.dart (Write)"?>

### HandHeld Readers

- RFD40XX
- RFD90XX
- MC33XXR
- RFD8500

### Fixed Readers

- FX7500
- FX9600

## Usage

### Examples

Here are small examples that show you how to use the API.

#### RFID Handheld readers Connection

<?code-excerpt "readme_excerpts.dart (Write)"?>

``` dart
// Obtain shared preferences.
final ZebraRfidReader reader = await ZebraRfidReader.getInstance();

// Connect to device
await reader.connect();
// Disconnect to device
await reader.disconnect();
```
