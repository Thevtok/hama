// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/loginPage.dart';
import 'package:hama/model/daily.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:hama/controller/dailyController.dart';
import '../home/jobPage.dart';
import '../monitoringPeralatan/fromData.dart';

class FromDataDailyActivity extends StatefulWidget {
  DateTime? selectedDateForGo;
  final String item;
  FromDataDailyActivity(
      {super.key, this.selectedDateForGo, required this.item});

  @override
  State<FromDataDailyActivity> createState() => _FromDataDailyActivityState();
}

class _FromDataDailyActivityState extends State<FromDataDailyActivity> {
  File? _selectedImage;
  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dailyController = Get.find<DailynController>();
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
              'Daily Activity',
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
              height: 20,
            ),
            tombolDaily(dailyController, context, widget.item),
            const SizedBox(
              height: 10,
            ),
            FormDataRow(
                labelText: 'Nama', controller: dailyController.namaController),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
                labelText: 'Lokasi',
                controller: dailyController.lokasiController),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
                labelText: 'Jenis Treatment',
                controller: dailyController.jenisController),
            const SizedBox(
              height: 5,
            ),
            FormDataRow(
                labelText: 'Hama Ditemukan',
                controller: dailyController.hamaController),
            const SizedBox(
              height: 5,
            ),
            FormDataNumber(
                labelText: 'Jumlah',
                controller: dailyController.jumlahController),
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
                controller: dailyController.keteranganController),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  AddButton tombolDaily(
      DailynController dailyController, BuildContext context, String order) {
    return AddButton(
        onTap: () async {
          if (_selectedImage != null) {
            String jumlahText = dailyController.jumlahController.text;
            int jumlah = int.tryParse(jumlahText) ?? 0;
            String urlFormat = DateFormat('yyyy-MM-dd')
                .format(widget.selectedDateForGo ?? DateTime.now());
            bool berhasilTambah = await dailyController.addDaily(
                Daily(
                    name: dailyController.namaController.text,
                    noOrder: widget.item,
                    jenisTreatment: dailyController.jenisController.text,
                    hamaDitemukan: dailyController.hamaController.text,
                    lokasi: dailyController.lokasiController.text,
                    jumlah: jumlah,
                    keterangan: dailyController.keteranganController.text,
                    tanggal: urlFormat),
                widget.item,
                _selectedImage!);
            dailyController.namaController.clear();
            dailyController.hamaController.clear();
            dailyController.lokasiController.clear();
            dailyController.jumlahController.clear();
            dailyController.jenisController.clear();
            dailyController.keteranganController.clear();
            setState(() {
              _selectedImage = null;
            });

            if (!berhasilTambah) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal menambahkan data!'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil ditambahkan!'),
                ),
              );
              await dailyController.fetchDaily(order);
            }
          }
        },
        text: 'Tambah Activity',
        lebar: 0.5);
  }
}

class ImageUploadRow extends StatefulWidget {
  final String labelText;
  final Function(File?) onImageSelected;

  const ImageUploadRow({
    Key? key,
    required this.labelText,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  _ImageUploadRowState createState() => _ImageUploadRowState();
}

class _ImageUploadRowState extends State<ImageUploadRow> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImageSelected(_imageFile);
    }
  }

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
              height: 100,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(border: Border.all()),
              child: _imageFile != null
                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                  : const Center(
                      child: Text('Tidak ada gambar'),
                    ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
