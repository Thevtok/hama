// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/inpeksiController.dart';
import 'package:hama/model/inpeksi.dart';

import '../dailyActivity/fromData.dart';
import '../dailyActivity/listData.dart';
import '../home/jobPage.dart';
import '../home/loginPage.dart';
import '../monitoringPeralatan/fromData.dart';
import '../monitoringPeralatan/listData.dart';
import '../perhitunganIndex/listPage.dart';

class ListDataInspeksi extends StatelessWidget {
  final String item;

  const ListDataInspeksi({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final inpeksiController = Get.put(InpeksiController(
      order: item,
    ));
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
              item,
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
              'Inspeksi Akses Hama',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            AddButton(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InpeksiDialog(
                            controller: inpeksiController, item: item);
                      });
                },
                text: 'Tambah Hasil Inspeksi',
                lebar: 0.6),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              if (inpeksiController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: inpeksiController.inpeksi.length,
                  itemBuilder: (BuildContext context, int index) {
                    final daily = inpeksiController.inpeksi[index];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 35,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: grey.withOpacity(0.1),
                                          border: Border.all(),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            daily.name ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ListDataRow(
                                          labelText: 'Lokasi',
                                          value: daily.lokasi ?? ''),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Tanggal',
                                          value: daily.tanggal ?? ''),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListImageRow(
                                          labelText: 'Bukti Foto',
                                          value: daily.buktiFoto),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Keterangan',
                                          value: daily.keterangan ?? ''),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      ListDataRow(
                                          labelText: 'Rekomendasi',
                                          value: daily.rekomendasi ?? ''),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class InpeksiDialog extends StatefulWidget {
  final InpeksiController controller;
  final String item;

  const InpeksiDialog(
      {super.key, required this.controller, required this.item});

  @override
  _InpeksiDialogState createState() => _InpeksiDialogState();
}

class _InpeksiDialogState extends State<InpeksiDialog> {
  File? _selectedImage;
  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              controller: widget.controller.namaController,
            ),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
              labelText: 'Lokasi',
              controller: widget.controller.lokasiController,
            ),
            const SizedBox(
              height: 5,
            ),
            FormDataDateRow(
                labelText: 'Tanggal',
                controller: widget.controller.tanggalController),
            const SizedBox(
              height: 5,
            ),
            ImageUploadRow(
              labelText: 'Bukti Foto',
              onImageSelected: _onImageSelected,
            ),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
              labelText: 'Keterangan',
              controller: widget.controller.keteranganController,
            ),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
              labelText: 'Rekomendasi',
              controller: widget.controller.rekomendasiController,
            ),
            const SizedBox(
              height: 50,
            ),
            AddButton(
                onTap: () async {
                  bool berhasil = await widget.controller.addInpeksi(
                      Inpeksi(
                        name: widget.controller.namaController.text,
                        noOrder: widget.item,
                        rekomendasi:
                            widget.controller.rekomendasiController.text,
                        lokasi: widget.controller.lokasiController.text,
                        keterangan: widget.controller.keteranganController.text,
                        tanggal: widget.controller.tanggalController.text,
                      ),
                      widget.item,
                      _selectedImage!);
                  widget.controller.namaController.clear();
                  widget.controller.lokasiController.clear();
                  widget.controller.rekomendasiController.clear();
                  widget.controller.keteranganController.clear();

                  widget.controller.tanggalController.clear();

                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil ditambahkan!'),
                      ),
                    );
                    await widget.controller.fetchInpeksi(widget.item);

                    Navigator.of(context).pop();
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
  }
}
