// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../home/jobPage.dart';
import '../home/loginPage.dart';
import 'attendance.dart';

class TimesheetPage extends StatefulWidget {
  final String item;
  final int id;

  const TimesheetPage({
    super.key,
    required this.item,
    required this.id,
  });

  @override
  _TimesheetPageState createState() => _TimesheetPageState();
}

class _TimesheetPageState extends State<TimesheetPage> {
  DateTime? _selectedDate;
  DateTime? _selectedDateForGo;
  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();
  }

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
            '${widget.id} - ${widget.item}',
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
            'Timesheet',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Pilih Tanggal',
            style: TextStyle(color: grey, fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: TableCalendar(
                shouldFillViewport: true,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(2030, 12, 31),
                focusedDay: _selectedDate ?? DateTime.now(),
                selectedDayPredicate: (selectedDay) {
                  return isSameDay(selectedDay, _selectedDate);
                },
                headerStyle: HeaderStyle(
                  headerPadding: const EdgeInsets.all(5),
                  headerMargin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                  ),
                  titleTextFormatter: (date, locale) => formattedDate,
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(fontWeight: FontWeight.bold)),
                calendarStyle: CalendarStyle(
                    rowDecoration: BoxDecoration(color: white),
                    weekendTextStyle: const TextStyle(fontSize: 10),
                    defaultTextStyle: const TextStyle(fontSize: 10),
                    outsideTextStyle: const TextStyle(fontSize: 10),
                    selectedTextStyle: TextStyle(fontSize: 10, color: white),
                    todayTextStyle: TextStyle(fontSize: 10, color: white),
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
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                _selectedDateForGo = _selectedDate;
                Get.to(() => AttendancePage(
                      item: widget.item,
                      id: widget.id,
                      selectedDateForGo: _selectedDateForGo,
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: blue,
                ),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Go',
                    style: TextStyle(
                      color: white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
