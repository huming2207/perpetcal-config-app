enum UsbPacketType {
  ack,
  deviceInfo,
  ping,
  chunkMetadata,
  chunkData,
  chunkAck,
  kvSetU32,
  kvGetU32,
  kvSetI32,
  kvGetI32,
  kvSetString,
  kvGetString,
  kvSetBlob,
  kvGetBlob,
  kvEntryCount,
  kvFlush,
  kvDeleteEntry,
  kvNuke,
  nack
}

extension UsbPacketTypeExt on UsbPacketType {
  int get type {
    switch (this) {
      case UsbPacketType.ack:
        return 0x00;
      case UsbPacketType.deviceInfo:
        return 0x01;
      case UsbPacketType.ping:
        return 0x02;
      case UsbPacketType.chunkMetadata:
        return 0x10;
      case UsbPacketType.chunkData:
        return 0x11;
      case UsbPacketType.chunkAck:
        return 0x12;
      case UsbPacketType.kvSetU32:
        return 0x20;
      case UsbPacketType.kvGetU32:
        return 0x21;
      case UsbPacketType.kvSetI32:
        return 0x22;
      case UsbPacketType.kvGetI32:
        return 0x23;
      case UsbPacketType.kvSetString:
        return 0x24;
      case UsbPacketType.kvGetString:
        return 0x25;
      case UsbPacketType.kvSetBlob:
        return 0x26;
      case UsbPacketType.kvGetBlob:
        return 0x27;
      case UsbPacketType.kvEntryCount:
        return 0x28;
      case UsbPacketType.kvFlush:
        return 0x29;
      case UsbPacketType.kvDeleteEntry:
        return 0x2a;
      case UsbPacketType.kvNuke:
        return 0x2b;
      case UsbPacketType.nack:
        return 0xff;
      default:
        return 0xff;
    }
  }
}

enum ChunkAckState { xferDone, xferNext, errHashFail, errInternal, errAbort, errNameTooLong }

extension ChunkAckStateExt on ChunkAckState {
  int get type {
    switch (this) {
      case ChunkAckState.xferDone:
        return 0;
      case ChunkAckState.xferNext:
        return 1;
      case ChunkAckState.errHashFail:
        return 2;
      case ChunkAckState.errInternal:
        return 3;
      case ChunkAckState.errAbort:
        return 4;
      case ChunkAckState.errNameTooLong:
        return 5;
      default:
        return 3;
    }
  }
}

class UsbPacketTypeHelper {
  static UsbPacketType byteToPktType(int value) {
    switch ((value & 0xff)) {
      case 0x00:
        return UsbPacketType.ack;
      case 0x01:
        return UsbPacketType.deviceInfo;
      case 0x02:
        return UsbPacketType.ping;
      case 0x10:
        return UsbPacketType.chunkMetadata;
      case 0x11:
        return UsbPacketType.chunkData;
      case 0x12:
        return UsbPacketType.chunkAck;
      case 0x20:
        return UsbPacketType.kvSetU32;
      case 0x21:
        return UsbPacketType.kvGetU32;
      case 0x22:
        return UsbPacketType.kvSetI32;
      case 0x23:
        return UsbPacketType.kvGetI32;
      case 0x24:
        return UsbPacketType.kvSetString;
      case 0x25:
        return UsbPacketType.kvGetString;
      case 0x26:
        return UsbPacketType.kvSetBlob;
      case 0x27:
        return UsbPacketType.kvGetBlob;
      case 0x28:
        return UsbPacketType.kvEntryCount;
      case 0x29:
        return UsbPacketType.kvFlush;
      case 0x2a:
        return UsbPacketType.kvDeleteEntry;
      case 0x2b:
        return UsbPacketType.kvNuke;
      default:
        return UsbPacketType.nack;
    }
  }

  static ChunkAckState byteToChunkAck(int value) {
    switch ((value & 0xff)) {
      case 0:
        return ChunkAckState.xferDone;
      case 1:
        return ChunkAckState.xferNext;
      case 2:
        return ChunkAckState.errHashFail;
      case 3:
        return ChunkAckState.errInternal;
      case 4:
        return ChunkAckState.errAbort;
      case 5:
        return ChunkAckState.errNameTooLong;
      default:
        return ChunkAckState.errInternal;
    }
  }
}
