import 'dart:convert';
import 'dart:typed_data';

import 'package:perpetcal/protocol/model/packet_header.dart';
import 'package:perpetcal/protocol/model/pkt_types.dart';

class RequestEncoder {
  static Uint8List encodePing() {
    final header = PacketHeader.fromType(UsbPacketType.ping);
    return header.fullPacketBytes;
  }

  static Uint8List encodeDeviceInfo() {
    final header = PacketHeader.fromType(UsbPacketType.deviceInfo);
    return header.fullPacketBytes;
  }

  static Uint8List encodeSetUint32(String key, int value) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final valueBytes = ByteData(4);
    valueBytes.setUint32(0, value, Endian.little);

    final packetBuilder = BytesBuilder();
    packetBuilder.add(keyBytes);
    packetBuilder.add(valueBytes.buffer.asUint8List());

    final header = PacketHeader(UsbPacketType.kvSetU32, packetBuilder.toBytes());
    return header.fullPacketBytes;
  }

  static Uint8List encodeSetInt32(String key, int value) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final valueBytes = ByteData(4);
    valueBytes.setUint32(0, value, Endian.little);

    final packetBuilder = BytesBuilder();
    packetBuilder.add(keyBytes);
    packetBuilder.addByte(value < 0 ? 1 : 0);
    packetBuilder.add(valueBytes.buffer.asUint8List());

    final header = PacketHeader(UsbPacketType.kvSetI32, packetBuilder.toBytes());
    return header.fullPacketBytes;
  }

  static Uint8List encodeSetString(String key, String value) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    var valueBytes = utf8.encode(value);
    if (valueBytes.length > 255) {
      valueBytes = valueBytes.sublist(0, 255);
    }

    final packetBuilder = BytesBuilder();
    packetBuilder.add(keyBytes);
    packetBuilder.addByte(valueBytes.length & 0xff);
    packetBuilder.add(valueBytes);

    final header = PacketHeader(UsbPacketType.kvSetString, packetBuilder.toBytes());
    return header.fullPacketBytes;
  }

  static Uint8List encodeSetBlob(String key, Uint8List value) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    var valueBytes = value;
    if (valueBytes.length > 255) {
      valueBytes = valueBytes.sublist(0, 255);
    }

    final packetBuilder = BytesBuilder();
    packetBuilder.add(keyBytes);
    packetBuilder.addByte(valueBytes.length & 0xff);
    packetBuilder.add(valueBytes);

    final header = PacketHeader(UsbPacketType.kvSetBlob, packetBuilder.toBytes());
    return header.fullPacketBytes;
  }

  static Uint8List encodeGetUint32(String key) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final header = PacketHeader(UsbPacketType.kvGetU32, keyBytes);
    return header.fullPacketBytes;
  }

  static Uint8List encodeGetInt32(String key) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final header = PacketHeader(UsbPacketType.kvGetI32, keyBytes);
    return header.fullPacketBytes;
  }

  static Uint8List encodeGetString(String key) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final header = PacketHeader(UsbPacketType.kvGetString, keyBytes);
    return header.fullPacketBytes;
  }

  static Uint8List encodeGetBlob(String key) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final header = PacketHeader(UsbPacketType.kvGetBlob, keyBytes);
    return header.fullPacketBytes;
  }

  static Uint8List encodeDelete(String key) {
    var keyBytes = ascii.encode(key);
    if (keyBytes.length > 15) {
      keyBytes = keyBytes.sublist(0, 15);
    }

    final header = PacketHeader(UsbPacketType.kvDeleteEntry, keyBytes);
    return header.fullPacketBytes;
  }

  static Uint8List encodeKvCounts() {
    final header = PacketHeader.fromType(UsbPacketType.kvEntryCount);
    return header.fullPacketBytes;
  }

  static Uint8List encodeKvFlush() {
    final header = PacketHeader.fromType(UsbPacketType.kvFlush);
    return header.fullPacketBytes;
  }

  static Uint8List encodeKvNuke() {
    final header = PacketHeader.fromType(UsbPacketType.kvNuke);
    return header.fullPacketBytes;
  }
}
