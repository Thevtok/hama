// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api, use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/loginPage.dart';
import 'package:hama/model/daily.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:hama/controller/dailyController.dart';
import '../home/jobPage.dart';
import '../monitoringPeralatan/fromData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
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
    Future<List<Daily>> fetchLocalData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? dataStrings =
          prefs.getStringList('daily_list${widget.item}');

      if (dataStrings != null) {
        // Mengonversi List<String> JSON kembali menjadi List<Daily>
        List<Daily> data = dataStrings.map((dataString) {
          Map<String, dynamic> jsonMap = jsonDecode(dataString);
          return Daily.fromJson(jsonMap);
        }).toList();

        return data;
      } else {
        return [];
      }
    }

    return AddButton(
        onTap: () async {
          final isConnected = await checkInternetConnection();
          if (isConnected) {
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
          } else {
            String jumlahText = dailyController.jumlahController.text;
            int jumlah = int.tryParse(jumlahText) ?? 0;
            String urlFormat = DateFormat('yyyy-MM-dd')
                .format(widget.selectedDateForGo ?? DateTime.now());

            String? base64Image;
            if (_selectedImage != null) {
              base64Image = Daily.imageToBase64(_selectedImage!.path);
            }

            Daily daily = Daily(
                name: dailyController.namaController.text,
                noOrder: widget.item,
                jenisTreatment: dailyController.jenisController.text,
                hamaDitemukan: dailyController.hamaController.text,
                lokasi: dailyController.lokasiController.text,
                jumlah: jumlah,
                keterangan: dailyController.keteranganController.text,
                tanggal: urlFormat,
                buktiFoto: base64Image,
                buktiFotoPath: _selectedImage?.path ?? '');
            List<Daily> existingData = await fetchLocalData();
            existingData.add(daily);
            print('Data setelah ditambahkan ke list: $existingData');
            List<Map<String, dynamic>> dataList =
                existingData.map((daily) => daily.toJson()).toList();

            // Menginisialisasi SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print('Data yang akan disimpan di SharedPreferences: $dataList');
            await prefs.setStringList('daily_list${widget.item}',
                dataList.map((data) => jsonEncode(data)).toList());

            dailyController.namaController.clear();
            dailyController.hamaController.clear();
            dailyController.lokasiController.clear();
            dailyController.jumlahController.clear();
            dailyController.jenisController.clear();
            dailyController.keteranganController.clear();
            setState(() {
              _selectedImage = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil disimpan secara lokal!'),
              ),
            );
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
      final sourcePath = pickedFile.path;
      final localImagePath = await _saveImageLocally(sourcePath);
      final localImageFile = File(localImagePath);

      setState(() {
        _imageFile = localImageFile;
      });
      widget.onImageSelected(localImageFile);
    }
  }

  Future<String> _saveImageLocally(String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(sourcePath); // Menggunakan nama file asli
    final destinationPath = path.join(directory.path, fileName);

    await File(sourcePath).copy(destinationPath);

    return destinationPath;
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
