import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

class KvGetResponseDecoder {
  static int decodeGetUInt32(Uint8List bytes) {
    return ByteData.sublistView(bytes).getUint32(0);
  }

  static int decodeGetInt32(Uint8List bytes) {
    final isNegative = bytes[0] != 0;
    final value = ByteData.sublistView(bytes).getUint32(1);
    return isNegative ? (value * -1) : value;
  }

  static String decodeGetString(Uint8List bytes) {
    final len = (bytes[0] & 0xff);
    final subList = bytes.sublist(1, min(len, 255)); // Max length cannot be longer than 255 bytes
    return ascii.decode(subList);
  }

  static Uint8List decodeGetBlob(Uint8List bytes) {
    final len = (bytes[0] & 0xff);
    return bytes.sublist(1, min(len, 255)); // Max length cannot be longer than 255 bytes
  }
}
