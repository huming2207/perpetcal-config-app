import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:perpetcal/protocol/model/device_info_pkt.dart';
import 'package:perpetcal/protocol/model/kv_get_deoder.dart';
import 'package:perpetcal/protocol/model/packet_header.dart';
import 'package:perpetcal/protocol/pkt_errors.dart';
import 'package:perpetcal/protocol/pkt_types.dart';
import 'package:perpetcal/protocol/slip_codec.dart';

class PacketCodec {
  late SlipCodec slipCodec;
  late SerialPortReader serialReader;
  final Completer _completer = Completer();

  PacketCodec(SerialPort port) {
    serialReader = SerialPortReader(port);
    slipCodec = SlipCodec(serialReader.stream, _onPacketReceived);
  }

  void _onPacketReceived(Uint8List bytes) {
    final header = PacketHeader.fromBytes(bytes);
    switch (header.type) {
      case UsbPacketType.ack:
        _completer.complete();
        break;
      case UsbPacketType.deviceInfo:
        _completer.complete(DeviceInfoPacket(header.body));
        break;
      case UsbPacketType.ping:
        _completer.complete();
        break;
      case UsbPacketType.chunkAck:
        _completer.complete(DeviceInfoPacket(header.body));
        break;
      case UsbPacketType.kvGetU32:
        _completer.complete(KvGetResponseDecoder.decodeGetUInt32(header.body));
        break;
      case UsbPacketType.kvGetI32:
        _completer.complete(KvGetResponseDecoder.decodeGetInt32(header.body));
        break;
      case UsbPacketType.kvGetString:
        _completer.complete(KvGetResponseDecoder.decodeGetString(header.body));
        break;
      case UsbPacketType.kvGetBlob:
        _completer.complete(KvGetResponseDecoder.decodeGetBlob(header.body));
        break;
      case UsbPacketType.nack:
        _completer.completeError(UsbPacketNackException('NACK received'));
        break;
      default:
        _completer.completeError(UsbPacketNackException('Unexpected packet type: ${header.type}'));
        break;
    }
  }
}
