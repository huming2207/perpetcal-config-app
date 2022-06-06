import 'dart:typed_data';

import 'package:perpetcal/protocol/pkt_errors.dart';
import 'package:perpetcal/protocol/pkt_hasher.dart';
import 'package:perpetcal/protocol/model/pkt_types.dart';

class PacketHeader {
  late UsbPacketType _type;
  late int _len;
  late int _crc;
  late Uint8List _body;

  PacketHeader.fromBytes(Uint8List bytes) {
    if (bytes.lengthInBytes <= 4) {
      throw UsbPacketCorruptException('Packet is corrupted (invalid length)');
    }

    _type = UsbPacketTypeHelper.byteToPktType(bytes[0]);
    _len = bytes[1];
    _crc = ((bytes[3] << 8) | (bytes[2])) & 0xffff;
    _body = bytes.sublist(4); // Body starts from 5th byte

    final headerBytes = Uint8List.fromList([_type.type & 0xff, _len & 0xff, 0, 0]);
    final headerCrc = PacketHasher.getCRC16(headerBytes);
    final combinedCrc = PacketHasher.getCRC16(headerBytes, headerCrc);

    if (_crc != combinedCrc) {
      throw UsbPacketCorruptException('CRC mismatch, expected ${_crc.toRadixString(16).padLeft(4, '0')}, got ${combinedCrc.toRadixString(16).padLeft(4, '0')}');
    }
  }

  PacketHeader(UsbPacketType type, Uint8List body) {
    _type = type;
    _len = body.length;
    _body = body;

    final headerBytes = Uint8List.fromList([type.type & 0xff, _len & 0xff, 0, 0]);
    final headerCrc = PacketHasher.getCRC16(headerBytes);
    _crc = PacketHasher.getCRC16(headerBytes, headerCrc);
  }

  PacketHeader.fromType(UsbPacketType type) {
    _type = type;
    _len = 0;
    _body = Uint8List(0);

    final headerBytes = Uint8List.fromList([type.type & 0xff, _len & 0xff, 0, 0]);
    _crc = PacketHasher.getCRC16(headerBytes);
  }

  UsbPacketType get type {
    return _type;
  }

  int get length {
    return _len;
  }

  int get crc {
    return _crc;
  }

  Uint8List get body {
    return _body;
  }

  Uint8List get headerBytes {
    return Uint8List.fromList([type.type & 0xff, _len & 0xff, _crc & 0xff, (_crc >> 8) & 0xff]);
  }

  Uint8List get fullPacketBytes {
    final builder = BytesBuilder();
    builder.add(headerBytes);
    builder.add(body);
    return builder.toBytes();
  }
}
