import 'package:get/get.dart';

import '../controllers/ongkir_controller.dart';

class OngkirBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OngkirController>(
      () => OngkirController(),
    );
  }
}
