// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, use_build_context_synchronously
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/peralatanController.dart';
import 'package:hama/model/peralatan.dart';
import 'package:intl/intl.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';

class FromDataPeralatan extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataPeralatan({
    Key? key,
    this.selectedDateForGo,
    required this.item,
  }) : super(key: key);

  @override
  State<FromDataPeralatan> createState() => _FromDataPeralatanState();
}

class _FromDataPeralatanState extends State<FromDataPeralatan> {
  @override
  Widget build(BuildContext context) {
    final peralatanController = Get.find<PeralatanController>();
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(widget.selectedDateForGo ?? DateTime.now());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            backLogout(context),
            richHama(context),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.item,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Monitoring Peralatan',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 40,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: grey.withOpacity(0.1),
                        border: Border.all(),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Tambah Data',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FormDataRow(
                        labelText: 'Nama',
                        controller: peralatanController.namaController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Merk',
                        controller: peralatanController.merkController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataNumber(
                        labelText: 'Jumlah',
                        controller: peralatanController.jumlahController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Satuan',
                        controller: peralatanController.satuanController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Kondisi',
                        controller: peralatanController.kondisiController),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AddButton(
                onTap: () async {
                  String jumlahText = peralatanController.jumlahController.text;
                  int jumlah = int.tryParse(jumlahText) ?? 0;
                  String urlFormat = DateFormat('yyyy-MM-dd')
                      .format(widget.selectedDateForGo ?? DateTime.now());
                  bool berhasil = await peralatanController.addPeralatans(
                      MonitoringPeralatan(
                          name: peralatanController.namaController.text,
                          noOrder: widget.item,
                          merek: peralatanController.merkController.text,
                          jumlah: jumlah,
                          satuan: peralatanController.satuanController.text,
                          kondisi: peralatanController.kondisiController.text,
                          tanggal: urlFormat),
                      widget.item);

                  peralatanController.namaController.clear();
                  peralatanController.merkController.clear();
                  peralatanController.jumlahController.clear();
                  peralatanController.satuanController.clear();
                  peralatanController.kondisiController.clear();

                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil ditambahkan!'),
                      ),
                    );
                    await peralatanController.fetchPeralatans(widget.item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data gagal ditambahkan!'),
                      ),
                    );
                  }
                },
                text: 'Save',
                lebar: 0.5)
          ],
        ),
      ),
    );
  }
}

class FormDataRow extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const FormDataRow(
      {super.key, required this.labelText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            labelText,
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
                controller: controller,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormDataNumber extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const FormDataNumber(
      {super.key, required this.labelText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            labelText,
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
                keyboardType: TextInputType.number,
                controller: controller,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
