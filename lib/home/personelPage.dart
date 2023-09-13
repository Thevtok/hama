// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'jobPage.dart';
import 'loginPage.dart';

class PersonelPage extends StatefulWidget {
  final String item;
  const PersonelPage({super.key, required this.item});

  @override
  State<PersonelPage> createState() => _PersonelPageState();
}

class _PersonelPageState extends State<PersonelPage> {
  List<String> personelData = [
    'Personel 1',
    'Personel 2',
    'Personel 3',
    'Personel 4',
    'Personel 5',
  ];
  void handleEdit(int index) {}

  void handleDelete(int index) {
    setState(() {
      personelData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          backLogout(context),
          richHama(context),
          const SizedBox(
            height: 50,
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
            'List Personel',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          Personnel(
              personelData: personelData,
              onEditPressed: handleEdit,
              onDeletePressed: handleDelete)
        ],
      ),
    );
  }
}

class Personnel extends StatelessWidget {
  final List<String> personelData; // Data personel
  final void Function(int) onEditPressed; // Callback saat tombol edit ditekan
  final void Function(int)
      onDeletePressed; // Callback saat tombol hapus ditekan

  const Personnel({
    super.key,
    required this.personelData,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: personelData.length,
      itemBuilder: (BuildContext context, int index) {
        final person = personelData[index];
        return Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    person,
                    style: TextStyle(color: grey, fontWeight: FontWeight.w500),
                  )),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                onEditPressed(index);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                onDeletePressed(index);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }
}
