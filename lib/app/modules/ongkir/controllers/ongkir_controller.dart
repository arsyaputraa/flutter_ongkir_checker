import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ongkir_checker/app/data/models/ongkir_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OngkirController extends GetxController {
  TextEditingController beratC = TextEditingController();

  RxBool isLoading = false.obs;
  RxString provinceAsal = "0".obs;
  RxString kotaAsal = "0".obs;
  RxString provinceTujuan = "0".obs;
  RxString kotaTujuan = "0".obs;
  RxString codeKurir = "".obs;

  List<Ongkir> ongkirList = <Ongkir>[];
  String serviceName = "";

  RxBool isDataFetched = false.obs;

  void cekOngkir() async {
    if (provinceAsal.value != "0" &&
        provinceTujuan.value != "0" &&
        kotaAsal.value != "0" &&
        kotaTujuan.value != "0" &&
        codeKurir.value.isNotEmpty &&
        beratC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        isDataFetched.value = false;
        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": 'c2b5556d2dad508cb165d9ea5bc07888',
            'content-type': 'application/x-www-form-urlencoded'
          },
          body: {
            "origin": kotaAsal.value,
            "destination": kotaTujuan.value,
            "weight": beratC.text,
            "courier": codeKurir.value,
          },
        );

        var res = jsonDecode(response.body)['rajaongkir']['results'][0];
        serviceName = res['name'];
        ongkirList = Ongkir.fromJsonList(res['costs']);
        isDataFetched.value = true;
        isLoading.value = false;
      } catch (e) {
        Get.defaultDialog(
          title: "terjadi kesalahan",
          content: Text("Gagal mendapatkan data\n${e.toString()}"),
        );
      }
    } else {
      Get.defaultDialog(
        title: "Data Kurang",
        content: const Text("Masukkan seluruh data yang dibutuhkan"),
      );
    }
  }
}
