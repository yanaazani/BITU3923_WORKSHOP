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
enum FilterStatus{pending,waiting, complete, cancel}

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

  FilterStatus getStatusEnum(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return FilterStatus.pending;
      case 'waiting':
        return FilterStatus.waiting;
      case 'complete':
        return FilterStatus.complete;
      case 'cancel':
        return FilterStatus.cancel;
      default:
        return FilterStatus.pending; // Set a default value or handle accordingly
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DefaultTabController(
                  length: FilterStatus.values.length,
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        status_bar = FilterStatus.values[index];
                        switch (status_bar) {
                          case FilterStatus.pending:
                            _alignment = Alignment.centerLeft;
                            break;
                          case FilterStatus.complete:
                            _alignment = Alignment.center;
                            break;
                          case FilterStatus.cancel:
                            _alignment = Alignment.centerRight;
                            break;
                          case FilterStatus.waiting:
                            _alignment = Alignment.topCenter; // Set it to the top center
                            break;
                        }
                      });
                    },
                    tabs: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Tab(
                          child: Text(filterStatus.name,
                            style: TextStyle(
                              fontSize: 13,),
                        ),
                        )
                    ],
                  ),
                ),
              ),

            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    //Appointment appointment = appointments[index];
                    if (index >= 0 && index < appointments.length) {
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
                                  ), // To display the appointment's date
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
                                  ), // To display the appointment's time
                                  Row(
                                      children: [
                                        Text('Rate your experience:  ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,),),
                                        content(),
                                      ]
                                  )  // Rating

                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Handle the case where the index is out of bounds
                      return SizedBox
                          .shrink(); // or another widget indicating no data
                    }
                  },
                    ))
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
            itemBuilder: (context, index) {
              switch(index) {
                case 0:
                  return Icon(Icons.sentiment_very_dissatisfied,
                      color: Colors.red);
                case 1:
                  return Icon(Icons.sentiment_neutral,
                      color: Colors.amber);
                case 2:
                  return Icon(Icons.sentiment_very_satisfied_outlined,
                      color: Colors.green);
                default:
                  return Text("");
              }
            },
            onRatingUpdate: (rating) {
              print(rating);
            })
      ],
    );
  }
}
