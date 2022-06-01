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
