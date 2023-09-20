// ignore_for_file: file_names, must_be_immutable, unused_local_variable, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/model/index.dart';
import 'package:intl/intl.dart';
import '../../controller/indexController.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/fromData.dart';
import 'listData.dart';

class ListIndex extends StatefulWidget {
  final String item;

  const ListIndex({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ListIndex> createState() => _ListIndexState();
}

class _ListIndexState extends State<ListIndex> {
  Set<String> tanggalSet = <String>{};

  @override
  Widget build(BuildContext context) {
    final indexController = Get.put(IndexController(order: widget.item));
    return Scaffold(
      body: Column(
        children: [
          backLogout(context),
          richHama(context),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.item,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25.0,
              color: grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Perhitungan Indeks',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          AddButton(
              onTap: () {
                showMyDialog(context, indexController, widget.item);
              },
              text: 'Tambah Isian',
              lebar: 0.5),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Form Perhitungan Indeks',
                style: TextStyle(color: grey, fontSize: 16),
              ),
            ),
          ),
          Obx(() {
            if (indexController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: indexController.indexs.length,
                itemBuilder: (BuildContext context, int index) {
                  final indexx = indexController.indexs[index];
                  if (!tanggalSet.contains(indexx.tanggal)) {
                    tanggalSet.add(indexx.tanggal);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () async {
                          Get.to(() => ListDataIndex(
                                item: widget.item,
                                selectedDateForGo: indexx.tanggal,
                              ));
                        },
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          padding: const EdgeInsets.all(5),
                          child: Text(indexx.tanggal),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }
          }),
        ],
      ),
    );
  }
}

void showMyDialog(
  BuildContext context,
  IndexController controller,
  String item,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        title: const Center(
          child: Text(
            'Tambah Isian',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              FormDataRow(
                labelText: 'Name',
                controller: controller.namaController,
              ),
              const SizedBox(
                height: 5,
              ),
              FormDataRow(
                labelText: 'Lokasi',
                controller: controller.lokasiController,
              ),
              const SizedBox(
                height: 5,
              ),
              FormDataDateRow(
                  labelText: 'Tanggal',
                  controller: controller.tanggalController),
              const SizedBox(
                height: 5,
              ),
              FormDataNumber(
                labelText: 'Jumlah',
                controller: controller.jumlahController,
              ),
              const SizedBox(
                height: 5,
              ),
              FormDataRow(
                labelText: 'Jenis Hama',
                controller: controller.jenisController,
              ),
              const SizedBox(
                height: 5,
              ),
              FormDataNumber(
                labelText: 'Indeks Populasi',
                controller: controller.indexController,
              ),
              const SizedBox(
                height: 5,
              ),
              FormDataRow(
                labelText: 'Status',
                controller: controller.statusController,
              ),
              const SizedBox(
                height: 50,
              ),
              AddButton(
                  onTap: () async {
                    String jumlahText = controller.jumlahController.text;
                    String indexText = controller.indexController.text;
                    int jumlah = int.tryParse(jumlahText) ?? 0;
                    int indexx = int.tryParse(indexText) ?? 0;

                    bool berhasil = await controller.addIndex(
                        PerhitunganIndex(
                            name: controller.namaController.text,
                            noOrder: item,
                            lokasi: controller.lokasiController.text,
                            jenisHama: controller.jenisController.text,
                            indeksPopulasi: indexx,
                            jumlah: jumlah,
                            tanggal: controller.tanggalController.text,
                            status: controller.statusController.text),
                        item);
                    controller.namaController.clear();
                    controller.lokasiController.clear();
                    controller.jenisController.clear();
                    controller.indexController.clear();
                    controller.jumlahController.clear();
                    controller.tanggalController.clear();
                    controller.statusController.clear();

                    if (berhasil) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data berhasil ditambahkan!'),
                        ),
                      );
                      await controller.fetchIndexs(item);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data gagal ditambahkan!'),
                        ),
                      );
                    }
                  },
                  text: 'Add',
                  lebar: 0.43),
            ],
          ),
        ),
      );
    },
  );
}

class FormDataDateRow extends StatefulWidget {
  final String labelText;
  late TextEditingController controller;

  FormDataDateRow(
      {super.key, required this.labelText, required this.controller});

  @override
  State<FormDataDateRow> createState() => _FormDataDateRowState();
}

class _FormDataDateRowState extends State<FormDataDateRow> {
  @override
  void initState() {
    widget.controller.text = ""; //set the initial value of text field
    super.initState();
  }

  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            widget.labelText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: 30,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(border: Border.all()),
              child: TextField(
                controller: widget.controller,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    setState(() {
                      widget.controller.text = formattedDate;
                    });
                  } else {}
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
