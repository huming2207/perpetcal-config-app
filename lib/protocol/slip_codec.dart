import 'dart:ffi';
import 'dart:typed_data';

const slipEnd = 0xc0;
const slipEsc = 0xdb;
const slipEscEnd = 0xdc;
const slipEscEsc = 0xdd;
const maxPacketLen = 520; // Approx worst case scenario packet length for raw packet (after SLIP encoded + with header)

const slipEscEndSeq = [slipEsc, slipEscEnd];
const slipEscEscSeq = [slipEsc, slipEscEsc];

class SlipCodec {
  // Future<Uint8List> decodeFromStream(Stream<Uint8List> stream) async {
  //   await for (final bytes in stream) {}

  // }
}
