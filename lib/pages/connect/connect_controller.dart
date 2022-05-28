import 'dart:async';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';

class ConnectController extends GetxController {
  ConnectController() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
      onPortRefresh,
    );
  }

  var ports = <String>[].obs;

  late Timer timer;

  void onPortRefresh(Timer timer) {
    ports.value = SerialPort.availablePorts;
    update(ports);
  }
}

class ConnectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConnectController());
  }
}
