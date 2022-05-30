import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:perpetcal/main.dart';
import 'package:perpetcal/pages/connect/connect_controller.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ConnectController>();
    var mainController = Get.find<MainController>();

    return Scaffold(
      body: Scrollbar(
          child: Obx(() => ListView(children: [
                for (final portAddr in controller.ports)
                  Builder(builder: (context) {
                    final port = SerialPort(portAddr);

                    if (port.vendorId == 0x303a && port.productId == 0x80fe) {
                      return Card(
                          child: ExpansionTile(
                        title: const Text('PerpetCal device'),
                        subtitle: Text(portAddr),
                        children: [
                          CardListTile('Manufacturer', port.manufacturer),
                          CardListTile('Product', port.productName),
                          CardListTile('Serial number', port.serialNumber),
                          CardListTile('PID', port.productId?.toRadixString(16))
                        ],
                        trailing: ElevatedButton(
                          onPressed: () => {mainController.changePort(portAddr)},
                          child: const Text('Connect'),
                        ),
                      ));
                    } else {
                      return Card(
                          child: ExpansionTile(
                        title: const Text('Unknown device'),
                        subtitle: Text(portAddr),
                        children: [
                          CardListTile('Manufacturer', port.manufacturer),
                          CardListTile('Product', port.productName),
                          CardListTile('Serial number', port.serialNumber),
                          CardListTile('PID', port.productId?.toRadixString(16))
                        ],
                      ));
                    }
                  })
              ]))),
    );
  }
}

class CardListTile extends StatelessWidget {
  final String? name;
  final String? value;

  CardListTile(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name ?? 'N/A'),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }
}
