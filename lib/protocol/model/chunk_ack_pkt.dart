import 'dart:typed_data';

import 'package:perpetcal/protocol/model/pkt_types.dart';

class ChunkAckPacket {
  late ChunkAckState ackState;
  late int auxInfo;

  ChunkAckPacket(Uint8List bytes) {
    ackState = UsbPacketTypeHelper.byteToChunkAck(bytes[0]);
    auxInfo = ByteData.sublistView(bytes.sublist(1, 5)).getUint32(0);
  }
}
