import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ongkir_checker/app/data/models/city_model.dart';
import 'package:flutter_ongkir_checker/app/data/models/province_model.dart';

import 'package:get/get.dart';

import '../controllers/ongkir_controller.dart';

class OngkirView extends GetView<OngkirController> {
  const OngkirView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir'),
        backgroundColor: Colors.red,
        leading: const BackButton(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 27, fontWeight: FontWeight.w500),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'TUJUAN PENGIRIMAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownSearch<Province>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Provinsi Asal',
                          ),
                        ),
                        asyncItems: GetProvinceList,
                        onChanged: (value) {
                          controller.provinceAsal.value =
                              value?.provinceId ?? "0";
                        },
                      ),
                      DropdownSearch<City>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Kota Asal',
                          ),
                        ),
                        itemAsString: (item) => "${item.type} ${item.cityName}",
                        asyncItems: (String Filter) =>
                            getCitiesList(controller.provinceAsal.value),
                        onChanged: (value) {
                          controller.kotaAsal.value = value?.cityId ?? "0";
                        },
                      ),
                      DropdownSearch<Province>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Provinsi Tujuan',
                          ),
                        ),
                        asyncItems: GetProvinceList,
                        onChanged: (value) {
                          controller.provinceTujuan.value =
                              value?.provinceId ?? "0";
                        },
                      ),
                      DropdownSearch<City>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Kota Tujuan',
                          ),
                        ),
                        itemAsString: (item) => "${item.type} ${item.cityName}",
                        asyncItems: (String Filter) =>
                            getCitiesList(controller.provinceTujuan.value),
                        onChanged: (value) {
                          controller.kotaTujuan.value = value?.cityId ?? "0";
                        },
                      ),
                      TextField(
                        controller: controller.beratC,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Berat (gram)',
                        ),
                      ),
                      DropdownSearch<Map<String, String>>(
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Kurir',
                          ),
                        ),
                        itemAsString: (item) => item["name"] ?? "",
                        items: const [
                          {"code": "jne", "name": "JNE"},
                          {"code": "tiki", "name": "TIKI"},
                          {"code": "pos", "name": "POS Indonesia"},
                        ],
                        onChanged: (value) {
                          controller.codeKurir.value = value?["code"] ?? "";
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => ElevatedButton(
                          onPressed: () {
                            if (controller.isLoading.isFalse)
                              controller.cekOngkir();
                          },
                          child: controller.isLoading.isFalse
                              ? const Text('CEK')
                              : const CircularProgressIndicator(),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => controller.isDataFetched.value
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        constraints: const BoxConstraints(minHeight: 300),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  const Text(
                                    'ONGKOS KIRIM',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.isDataFetched.value = false;
                                    },
                                    child: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const CircleAvatar(),
                                titleAlignment: ListTileTitleAlignment.bottom,
                                title: Text(
                                  controller.serviceName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...controller.ongkirList.map(
                                (e) {
                                  return ListTile(
                                    leading: const Icon(Icons.inbox),
                                    title: Text(e.service!),
                                    subtitle: Text(
                                      '${e.cost![0].etd} hari sampai',
                                    ),
                                    trailing: Text(
                                      'Rp ${e.cost![0].value}',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  );
                                },
                              ).toList()
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<City>> getCitiesList(String provinceId) async {
    var response = await Dio().get(
      "https://api.rajaongkir.com/starter/city?province=${provinceId}",
      queryParameters: {"key": 'c2b5556d2dad508cb165d9ea5bc07888'},
    );
    var models = City.fromJsonList(response.data['rajaongkir']['results']);
    return models;
  }

  Future<List<Province>> GetProvinceList(String filter) async {
    var response = await Dio().get(
      "https://api.rajaongkir.com/starter/province",
      queryParameters: {"key": 'c2b5556d2dad508cb165d9ea5bc07888'},
    );
    var models = Province.fromJsonList(response.data['rajaongkir']['results']);
    return models;
  }
}
