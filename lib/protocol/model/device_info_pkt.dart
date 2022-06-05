import 'dart:convert';
import 'dart:typed_data';

class DeviceInfoPacket {
  late Uint8List macAddr;
  late Uint8List flashId;
  late String sdkVersion;
  late String deviceModel;
  late String deviceBuild;

  DeviceInfoPacket(Uint8List bytes) {
    macAddr = bytes.sublist(0, 6); // 0-5; 6 bytes
    flashId = bytes.sublist(6, 14); // 6-13; 8 bytes

    final sdkVerionBytes = bytes.sublist(14, 46); // 14-45; 32 bytes
    final deviceModelBytes = bytes.sublist(46, 78); // 46-77; 32 bytes
    final deviceBuildBytes = bytes.sublist(78, 110); // 78-109; 32 bytes

    sdkVersion = ascii.decode(sdkVerionBytes);
    deviceModel = ascii.decode(deviceModelBytes);
    deviceBuild = ascii.decode(deviceBuildBytes);
  }
}
