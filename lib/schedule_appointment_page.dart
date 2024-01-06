import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ui/model/appointment_model.dart';
import 'package:ui/qrscanner.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final int userId;

  const ScheduleAppointmentPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

enum FilterStatus { pending, complete, waiting }

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  late final int userId;
  FilterStatus status_bar = FilterStatus.pending;
  List<Appointment> appointments = [];

  Future<List<Appointment>> getAppointmentsByStatusAndUser(String status) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.10:8080/pkums/appointment/getstatus/$status/patient/$userId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Appointment> appointments =
        jsonResponse.map((data) => Appointment.fromJson(data)).toList();

        setState(() {
          this.appointments = appointments;
        });
        return appointments;
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e, stackTrace) {
      print('Error in getAppointmentsByStatusAndUser: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Schedule"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                filterIconButton(FilterStatus.pending, "Pending"),
                filterIconButton(FilterStatus.waiting, "Waiting"),
                filterIconButton(FilterStatus.complete, "Complete"),
              ],
            ),
          ),
          Expanded(
            child: appointments.isEmpty
                ? const Center(child: Text('No Appointments'))
                : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                Appointment appointment = appointments[index];
                return AppointmentCard(appointment: appointment);
              },
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton filterIconButton(FilterStatus filter, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          status_bar = filter;
          getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
        });
      },
      style: ElevatedButton.styleFrom(
        primary: status_bar == filter ? Colors.deepPurple[50] : Colors.deepPurple[300],
      ),
      child: Text(label),
    );
  }
}

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {

  bool buttonEnabled = false;

  DateTime convertToDateTime(String appointmentDateTime){
    // Define the date format for parsing
    DateFormat dateFormat = DateFormat("yyyy-M-dd h:mma");

    // Parse the string to a DateTime object
    DateTime dateTime = dateFormat.parse(appointmentDateTime);


    return dateTime;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.appointment.bookingDate);
    print(widget.appointment.bookingTime);

    String appointmentDateTime = "${widget.appointment.bookingDate} ${widget.appointment.bookingTime}";

    print(appointmentDateTime);

    DateTime bookingTimeStamp = convertToDateTime(appointmentDateTime);
    print(bookingTimeStamp);



  }



  @override
  Widget build(BuildContext context) {




    String formattedDate = widget.appointment.bookingDate.split('-').map((part) {
      return part.padLeft(2, '0'); // Ensure two digits for each part
    }).join('-');
    DateTime bookingDateTime = DateTime.parse(formattedDate);
    Duration difference = bookingDateTime.difference(DateTime.now());

    bool canCheckIn =  widget.appointment.status.toLowerCase() == "Waiting" && difference <= const Duration(minutes: 30);

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.appointment.serviceType,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Date: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.appointment.bookingDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Time: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.appointment.bookingTime,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (widget.appointment.status.toLowerCase() == "complete")
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 20.0,
                itemBuilder: (context, index) {
                  switch(index) {
                    case 0:
                      return const Icon(Icons.sentiment_very_dissatisfied,
                          color: Colors.red);
                    case 1:
                      return const Icon(Icons.sentiment_neutral,
                          color: Colors.amber);
                    case 2:
                      return const Icon(Icons.sentiment_very_satisfied_outlined,
                          color: Colors.green);
                    default:
                      return const Text("");
                  }
                },
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ElevatedButton(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (Context) => QRScannerPage()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple[50],
              ),
              child: const Text('Check-In'),
            ),
          ],
        ),
      ),
    );
  }
}