import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'model/appointment_model.dart';
import 'model/patient_model.dart';

/**
 * This class will display 2 status
 * upcoming appointments  status and complete appointments status
 */

class ScheduleAppointmentPage extends StatefulWidget {
  final int userId;
  const ScheduleAppointmentPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

//enum for appointment status
enum FilterStatus{pending, complete, cancel}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {

  late final int userId;
  Patient? _patient;
  FilterStatus status_bar = FilterStatus.pending; // Initial status
  Alignment _alignment = Alignment.centerLeft;
  int appointmentId = 0;
  String bookingDate = "",
      bookingTime = "",
      status = "",
      serviceType = "";

  late List<Appointment> appointments = [];

  Future<List<Appointment>> getAppointment() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.0.10:8080/pkums/appointment/list/${widget.userId}'));
      if (response.statusCode == 200) {
        // Parse the JSON response into a `Patient` object.
        //final appointment = Appointment.fromJson(jsonDecode(response.body));
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Appointment> appointments = jsonResponse.map((data) =>
            Appointment.fromJson(data)).toList();


        print("This is user id: $userId");

        setState(() {
          _patient =
          appointments.isNotEmpty ? appointments.first.patient : null;

          // Use the appointments list instead of the undefined variable
          appointmentId = appointments.isNotEmpty
              ? appointments.first.appointmentId
              : 0;
          bookingDate = appointments.isNotEmpty
              ? appointments.first.bookingDate
              : "";
          bookingTime = appointments.isNotEmpty
              ? appointments.first.bookingTime
              : "";
          status = appointments.isNotEmpty
              ? appointments.first.status
              : "";
          serviceType = appointments.isNotEmpty
              ? appointments.first.serviceType
              : "";
          this.appointments = appointments; // Update the appointments list
        });
        return appointments;
      } else {
        throw Exception('Failed to fetch appointment');
      }
    }catch (e, stackTrace) {
      print('Error in listAppointment: $e');
      print('Stack trace: $stackTrace');
      // Handle the exception or rethrow if needed
      throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // Initialize userId using widget.userId
    getAppointment();
  }

  @override
  Widget build(BuildContext context) {
    //returned filtered appointment
    /*List<Appointment> filteredAppointments = appointments.where((appointment) {
      return appointment.status == status_bar
          .toString()
          .split('.')
          .last;
    }).toList();*/

    List<Appointment> filteredAppointments = appointments.where((appointment) {
      // Return true only if the appointment status matches status_bar
      return appointment.status == status_bar;
    }).toList();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Container(child: const Text("Schedule"),),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              const Padding(padding: EdgeInsets.all(8.0),),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for(FilterStatus filterStatus in FilterStatus.values)
                      Expanded(child: GestureDetector(
                        onTap: () {
                          setState(() {
                            status_bar = filterStatus;
                            _alignment = filterStatus == FilterStatus.pending
                                ? Alignment.centerLeft
                                : filterStatus == FilterStatus.complete
                                ? Alignment.center
                                : Alignment.centerRight;
                          });
                        },
                        child: Center(
                          child: Text(filterStatus.name),
                        ),
                      ))
                  ],
                ),
              ),
              AnimatedAlign(alignment: _alignment,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      status_bar.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                ),)
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    Appointment appointment = appointments[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.serviceType,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text('Date: ', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    Text(
                                      appointment.bookingDate,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Time: ', style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,),
                                    ),
                                    Text(
                                      appointment.bookingTime,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                    children: [
                                      Text('Rate your experience:  ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,),),
                                      content(),
                                    ]
                                )

                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }


  Widget content() {
    return Row(
      children: [
        RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30,
            itemBuilder: (context, _) =>
                Icon(Icons.star,
                  color: Colors.amber,
                ),
            onRatingUpdate: (rating) {
              print(rating);
            })
      ],
    );
  }
}
