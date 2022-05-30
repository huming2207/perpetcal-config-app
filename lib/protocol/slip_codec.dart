import 'dart:typed_data';

const slipEnd = 0xc0;
const slipEsc = 0xdb;
const slipEscEnd = 0xdc;
const slipEscEsc = 0xdd;
const slipEscEndSeq = [slipEsc, slipEscEnd];
const slipEscEscSeq = [slipEsc, slipEscEsc];

class SlipCodec {
  var recvStarted = false;
  var escDetected = false;
  final decodedBuilder = BytesBuilder();
  Stream<Uint8List> recvStream;
  Function(Uint8List) onPacketRecv;

  SlipCodec(this.recvStream, this.onPacketRecv) {
    recvStream.listen(_onRecvData, onError: null, onDone: _onRecvDone);
  }

  Uint8List encode(Uint8List data) {
    final encodedData = BytesBuilder();
    encodedData.addByte(slipEnd);
    for (final byte in data) {
      if (byte == slipEnd) {
        encodedData.add(slipEscEndSeq);
      } else if (byte == slipEsc) {
        encodedData.add(slipEscEscSeq);
      } else {
        encodedData.addByte(byte);
      }
    }
    encodedData.addByte(slipEnd);
    return encodedData.toBytes();
  }

  void _onRecvData(Uint8List bytes) {
    for (final byte in bytes) {
      switch (byte) {
        case slipEnd:
          {
            if (recvStarted) {
              recvStarted = false;
              escDetected = false;
              onPacketRecv(decodedBuilder.toBytes());
              break;
            } else {
              recvStarted = true;
              escDetected = false;
              decodedBuilder.clear();
            }
            break;
          }

        case slipEsc:
          {
            escDetected = true;
            break;
          }

        case slipEscEnd:
          {
            if (escDetected) {
              decodedBuilder.addByte(slipEnd);
            } else {
              decodedBuilder.addByte(slipEscEnd);
            }
            break;
          }

        case slipEscEsc:
          {
            if (escDetected) {
              decodedBuilder.addByte(slipEsc);
            } else {
              decodedBuilder.addByte(slipEscEsc);
            }
            break;
          }

        default:
          {
            decodedBuilder.addByte(byte);
            break;
          }
      }
    }
  }

  void _onRecvDone() {}
}
