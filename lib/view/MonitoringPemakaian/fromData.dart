// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/pemakaianController.dart';
import 'package:hama/model/pemakaian.dart';
import '../home/loginPage.dart';

import 'package:intl/intl.dart';

import '../home/jobPage.dart';
import '../home/orderPage.dart';
import '../monitoringPeralatan/fromData.dart';

class FromDataMonitoringPemakaian extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataMonitoringPemakaian({
    Key? key,
    this.selectedDateForGo,
    required this.item,
  }) : super(key: key);

  @override
  State<FromDataMonitoringPemakaian> createState() =>
      _FromDataMonitoringPemakaianState();
}

class _FromDataMonitoringPemakaianState
    extends State<FromDataMonitoringPemakaian> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM dd, yyyy')
        .format(widget.selectedDateForGo ?? DateTime.now());

    final pemakaianController =
        Get.put(PemakaianController(order: widget.item, tanggal: ''));
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
              'Monitoring Pemakaian',
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
                height: MediaQuery.of(context).size.height * 0.4,
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
                        controller: pemakaianController.namaController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Bahan Aktif',
                        controller: pemakaianController.bahanController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Merk',
                        controller: pemakaianController.merkController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataNumber(
                        labelText: 'Stok Awal',
                        controller: pemakaianController.stokAwalController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Satuan',
                        controller: pemakaianController.satuanController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataMutasi(
                      labelText: 'Mutasi',
                      inController: pemakaianController.insController,
                      outController: pemakaianController.outsController,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataNumber(
                        labelText: 'Stok Akhir',
                        controller: pemakaianController.stokAkhirController),
                    const SizedBox(
                      height: 5,
                    ),
                    FormDataRow(
                        labelText: 'Satuan',
                        controller: pemakaianController.satuanBController),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AddButton(
                onTap: () async {
                  String jumlahText =
                      pemakaianController.stokAwalController.text;
                  int stokAwal = int.tryParse(jumlahText) ?? 0;
                  String jumlahA = pemakaianController.stokAkhirController.text;
                  int stokAkhir = int.tryParse(jumlahA) ?? 0;
                  String inText = pemakaianController.insController.text;
                  int inA = int.tryParse(inText) ?? 0;
                  String outText = pemakaianController.outsController.text;
                  int outB = int.tryParse(outText) ?? 0;
                  String urlFormat = DateFormat('yyyy-MM-dd')
                      .format(widget.selectedDateForGo ?? DateTime.now());
                  bool berhasil = await pemakaianController.addPemakaian(
                      Pemakaian(
                          name: pemakaianController.namaController.text,
                          noOrder: widget.item,
                          satuanb: pemakaianController.satuanBController.text,
                          ins: inA,
                          out: outB,
                          satuan: pemakaianController.satuanController.text,
                          stokAwal: stokAwal,
                          stokAkhir: stokAkhir,
                          merk: pemakaianController.merkController.text,
                          bahanAktif: pemakaianController.bahanController.text,
                          tanggal: urlFormat),
                      widget.item);

                  pemakaianController.namaController.clear();
                  pemakaianController.merkController.clear();
                  pemakaianController.stokAwalController.clear();
                  pemakaianController.stokAkhirController.clear();
                  pemakaianController.bahanController.clear();
                  pemakaianController.satuanBController.clear();
                  pemakaianController.satuanController.clear();

                  pemakaianController.insController.clear();
                  pemakaianController.outsController.clear();

                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil ditambahkan!'),
                      ),
                    );
                    Get.off(OrderPage());
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

class FormDataMutasi extends StatelessWidget {
  final String labelText;
  final TextEditingController inController;
  final TextEditingController outController;

  const FormDataMutasi(
      {super.key,
      required this.labelText,
      required this.inController,
      required this.outController});

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
        const Text(
          'In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
                controller: inController,
              ),
            ),
          ),
        ),
        const Text(
          'Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
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
                controller: outController,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
