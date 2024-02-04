import 'package:flutter/material.dart';
import 'package:flutter_ongkir_checker/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracker'),
        backgroundColor: Colors.red,
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 27, fontWeight: FontWeight.w500),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10),
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(Routes.ONGKIR);
            },
            child: ListTile(
              title: Text('Cek Ongkos Kirim'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          InkWell(
            onTap: () {
              print('tapped');
            },
            child: ListTile(
              title: Text('Cek Resi'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
