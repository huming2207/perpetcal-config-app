class UsbPacketCorruptException implements Exception {
  String cause;
  UsbPacketCorruptException(this.cause);
}

class UsbPacketTooLongException implements Exception {
  String cause;
  UsbPacketTooLongException(this.cause);
}

class UsbConfigKeyTooLongException implements Exception {
  String cause;
  UsbConfigKeyTooLongException(this.cause);
}

class UsbPacketNackException implements Exception {
  String cause;
  UsbPacketNackException(this.cause);
}

class UsbPacketTimeoutException implements Exception {
  String cause;
  UsbPacketTimeoutException(this.cause);
}
