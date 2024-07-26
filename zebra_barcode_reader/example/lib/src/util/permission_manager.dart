import 'package:permission_handler/permission_handler.dart';

/// Permission manager
class PermissionManager {
  PermissionManager._privateConstructor();

  static final PermissionManager _instance =
      PermissionManager._privateConstructor();

  static PermissionManager get instance => _instance;

  /// Check and request location permission
  void checkAndRequestBluetoothPermission() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();
  }
}
