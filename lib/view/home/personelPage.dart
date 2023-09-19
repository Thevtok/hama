// ignore_for_file: file_names, use_build_context_synchronously, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hama/controller/personelController.dart';

import 'package:hama/model/personel.dart';

import 'jobPage.dart';
import 'loginPage.dart';

class PersonelPage extends StatelessWidget {

  final String item;
  final int id;
 

  const PersonelPage(
      {Key? key,
      required this.item,
      required this.id,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      final personelController = Get.put(PersonelController(order: item,tanggal: ''));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            backLogout(context),
            richHama(context),
            const SizedBox(
              height: 50,
            ),
            Text(
              ('$id - $item'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25.0,
                color: grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            AddButton(
                onTap: () {
                  showPersonelDialog(context, item, personelController);
                },
                text: 'Tambah Personel',
                lebar: 0.4),
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
            Obx(
              () {
                if (personelController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Personnel(
                    personelData: personelController.personels.value,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

void showPersonelDialog(
    BuildContext context, String order, PersonelController controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 194, 193, 191),
        title: const Center(
          child: Text(
            'Tambah Personel',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text('Nama'),
                  ),
                  Container(
                    height: 30,
                    width: 120,
                    decoration: BoxDecoration(border: Border.all()),
                    child: TextField(
                      controller: controller.nameText,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              AddButton(
                  onTap: () async {
                    await controller.addPersonel(
                        order, controller.nameText.text);
                    controller.nameText.text = '';
                    await controller.getPersonels(order);

                    Navigator.of(context).pop();
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

class Personnel extends StatelessWidget {
  final List<Personel> personelData;

  const Personnel({
    super.key,
    required this.personelData,
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
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  person.name,
                  style: TextStyle(
                    color: grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }
}
