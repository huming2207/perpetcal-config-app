import 'dart:async';
import 'dart:typed_data';

import 'package:mutex/mutex.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:perpetcal/protocol/model/device_info_pkt.dart';
import 'package:perpetcal/protocol/model/kv_get_deoder.dart';
import 'package:perpetcal/protocol/model/packet_header.dart';
import 'package:perpetcal/protocol/pkt_errors.dart';
import 'package:perpetcal/protocol/model/pkt_types.dart';
import 'package:perpetcal/protocol/request_encoder.dart';
import 'package:perpetcal/protocol/slip_codec.dart';

class PacketCodec {
  SerialPort port;
  late SlipCodec slipCodec;
  late SerialPortReader serialReader;

  final mutex = Mutex();
  final Completer _completer = Completer();

  PacketCodec(this.port) {
    serialReader = SerialPortReader(port);
    slipCodec = SlipCodec(serialReader.stream, _onPacketReceived);
  }

  void _onPacketReceived(Uint8List bytes) {
    mutex.release();
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

  Future<void> pingDevice() async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodePing();
    port.write(slipCodec.encode(pkt));

    return _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('Ping timeout');
      },
    );
  }

  Future<DeviceInfoPacket> requestDeviceInfo() async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeDeviceInfo();
    port.write(slipCodec.encode(pkt));

    final result = await _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('Request device info timeout');
      },
    );

    return result as DeviceInfoPacket;
  }

  Future<int> kvGetU32(String key) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeGetUint32(key);
    port.write(slipCodec.encode(pkt));

    final result = await _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvGetU32 request timeout');
      },
    );

    return result as int;
  }

  Future<int> kvGetI32(String key) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeGetInt32(key);
    port.write(slipCodec.encode(pkt));

    final result = await _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvGetI32 request timeout');
      },
    );

    return result as int;
  }

  Future<String> kvGetString(String key) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeGetInt32(key);
    port.write(slipCodec.encode(pkt));

    final result = await _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvGetString request timeout');
      },
    );

    return result as String;
  }

  Future<Uint8List> kvGetBlob(String key) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeGetInt32(key);
    port.write(slipCodec.encode(pkt));

    final result = await _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvGetBlob request timeout');
      },
    );

    return result as Uint8List;
  }

  Future<void> kvSetU32(String key, int value) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeSetUint32(key, value);
    port.write(slipCodec.encode(pkt));

    return _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvSetU32 request timeout');
      },
    );
  }

  Future<void> kvSetI32(String key, int value) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeSetInt32(key, value);
    port.write(slipCodec.encode(pkt));

    return _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvSetI32 request timeout');
      },
    );
  }

  Future<void> kvSetString(String key, String value) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeSetString(key, value);
    port.write(slipCodec.encode(pkt));

    return _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvSetString request timeout');
      },
    );
  }

  Future<void> kvSetBlob(String key, Uint8List value) async {
    await mutex.acquire();
    final pkt = RequestEncoder.encodeSetBlob(key, value);
    port.write(slipCodec.encode(pkt));

    return _completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        mutex.release();
        throw UsbPacketTimeoutException('KvSetBlob request timeout');
      },
    );
  }
}
