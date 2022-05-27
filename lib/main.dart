import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/main',
    defaultTransition: Transition.fade,
    getPages: [
      GetPage(name: '/main', page: () => const MainPage(), binding: MainBinding()),
    ],
  ));
}

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}

class MainController extends GetxController {
  static MainController get to => Get.find();
  var currIdx = 0.obs;
  final pages = <String>['/connect', '/wifi', '/ical', '/ota'];

  void changePage(int idx) {
    currIdx.value = idx;
    Get.toNamed(pages[idx], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/connect') {
      return GetPageRoute(
        settings: settings,
        page: () => const Text('Connection'),
      );
    }

    if (settings.name == '/wifi') {
      return GetPageRoute(
        settings: settings,
        page: () => const Text('WiFi Setup'),
      );
    }

    if (settings.name == '/ical') {
      return GetPageRoute(
        settings: settings,
        page: () => const Text('iCal'),
      );
    }

    if (settings.name == '/ota') {
      return GetPageRoute(
        settings: settings,
        page: () => const Text('OTA'),
      );
    }

    return null;
  }
}

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Navigator(
          initialRoute: '/connect',
          key: Get.nestedKey(1),
          onGenerateRoute: controller.onGenerateRoute,
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
                backgroundColor: Colors.blueGrey,
                selectedItemColor: Colors.orange[500],
                unselectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                onTap: controller.changePage,
                currentIndex: controller.currIdx.value,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.usb), label: 'Connection'),
                  BottomNavigationBarItem(icon: Icon(Icons.wifi), label: 'WiFi'),
                  BottomNavigationBarItem(icon: Icon(Icons.edit_calendar), label: 'Calendar'),
                  BottomNavigationBarItem(icon: Icon(Icons.system_update), label: 'System Upgrade')
                ])));
  }
}
