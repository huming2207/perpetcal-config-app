class UsbPacketCorruptException implements Exception {
  String cause;
  UsbPacketCorruptException(this.cause);
}

class UsbPacketTooLongException implements Exception {
  String cause;
  UsbPacketTooLongException(this.cause);
}
