import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/monitoringPeralatan/fromData.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';

class DatePeralatan extends StatefulWidget {
  final String item;
  const DatePeralatan({super.key, required this.item});

  @override
  State<DatePeralatan> createState() => _DatePeralatanState();
}

class _DatePeralatanState extends State<DatePeralatan> {
  DateTime? _selectedDate;
  DateTime? _selectedDateForGo;
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('MMMM dd, yyyy').format(_selectedDate ?? DateTime.now());
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
            'Daily Activity',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: grey.withOpacity(0.3),
                      border: Border.all(width: 1)),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Tambah Form',
                      style: TextStyle(
                          color: white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pilih Tanggal',
                        style: TextStyle(
                          color: dark,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.68,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: calender(formattedDate),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  AddButton(
                      onTap: () {
                        _selectedDateForGo = _selectedDate;

                        Get.to(FromDataPeralatan(
                          item: widget.item,
                          selectedDateForGo: _selectedDateForGo,
                        ));
                      },
                      text: 'Add',
                      lebar: 0.5)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  TableCalendar<dynamic> calender(String formattedDate) {
    return TableCalendar(
                          shouldFillViewport: true,
                          firstDay: DateTime(2023, 1, 1),
                          lastDay: DateTime(2030, 12, 31),
                          focusedDay: _selectedDate ?? DateTime.now(),
                          selectedDayPredicate: (selectedDay) {
                            return isSameDay(selectedDay, _selectedDate);
                          },
                          headerStyle: HeaderStyle(
                            titleTextStyle: const TextStyle(fontSize: 12),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 231, 228, 228),
                            ),
                            titleTextFormatter: (date, locale) =>
                                formattedDate,
                            titleCentered: true,
                            formatButtonVisible: false,
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              decoration: BoxDecoration(color: white),
                              weekdayStyle: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              weekendStyle: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          calendarStyle: CalendarStyle(
                              rowDecoration: BoxDecoration(color: white),
                              weekendTextStyle: const TextStyle(fontSize: 10),
                              defaultTextStyle: const TextStyle(fontSize: 10),
                              outsideTextStyle: const TextStyle(fontSize: 10),
                              selectedTextStyle:
                                  TextStyle(fontSize: 10, color: white),
                              todayTextStyle:
                                  TextStyle(fontSize: 10, color: white),
                              selectedDecoration: BoxDecoration(
                                color: grey,
                                shape: BoxShape.rectangle,
                              ),
                              todayDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: grey,
                              )),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDate = selectedDay;
                            });
                          },
                        );
  }
}
