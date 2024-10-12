import 'dart:io';

class DeviceUtil {
  static bool get isMobileDevice => Platform.isAndroid || Platform.isIOS;

  static bool get isPCDevice => !isMobileDevice;
}
