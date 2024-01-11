import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:ui/OneSignalController.dart';
import 'package:ui/model/appointment_model.dart';
import 'success_booking.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  final int userId;

  const ScheduleAppointmentPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

enum FilterStatus { pending, complete, waiting }

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  late int userId;
  FilterStatus status_bar = FilterStatus.pending;
  List<Appointment> appointments = [];

  Future<void> getAppointmentsByStatusAndUser(String status) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.10:8080/pkums/'
            'appointment/getstatus/$status/patient/$userId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Appointment> appointments =
        jsonResponse.map((data) => Appointment.fromJson(data)).toList();

        setState(() {
          this.appointments = appointments;
        });
      } else {
        throw Exception('Failed to fetch appointments');
      }
    } catch (e, stackTrace) {
      print('Error in getAppointmentsByStatusAndUser: $e');
      print('Stack trace: $stackTrace');
      throw e;
    }
  }

  Future<void> rateAppointment(int appointmentId, int rating) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.10:8080/pkums/appointment/updateservicerate'
            '/$appointmentId/$rating'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'rating': rating}),
      );

      if (response.statusCode == 200) {
        print('Rating updated successfully');
      } else {
        print('Failed to update rating. Status code: ${response.statusCode}');
        // Handle the error accordingly
      }
    } catch (e, stackTrace) {
      print('Error in rateAppointment: $e');
      print('Stack trace: $stackTrace');
      // Handle the error accordingly
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
        title: Text("Schedule"),
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
            child: appointments.isNotEmpty && appointments.any((appointment) {
              DateTime bookingDateTime = DateTime.parse(appointment.bookingDate.split('-').map((part) {
                return part.padLeft(2, '0'); // Ensure two digits for each part
              }).join('-'));
              DateTime currentDate = DateTime.now();
              return bookingDateTime.isAfter(currentDate) || bookingDateTime.day == currentDate.day;
            })
                ? ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                final appointment = appointments[index];
                DateTime bookingDateTime = DateTime.parse(appointment.bookingDate.split('-').map((part) {
                  return part.padLeft(2, '0'); // Ensure two digits for each part
                }).join('-'));
                DateTime currentDate = DateTime.now();
                bool isOnOrAfterCurrentDay = bookingDateTime.isAfter(currentDate) || bookingDateTime.day == currentDate.day;

                if (isOnOrAfterCurrentDay) {
                  return AppointmentCard(
                    appointment: appointment,
                    userId: userId,
                    rateAppointment: rateAppointment, // Pass the rateAppointment function here
                  );
                } else {
                  return SizedBox(); // Return an empty container if not meeting the condition
                }
              },
            )
                : Center(child: Text('No Appointments')),
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
  late final int userId;

  final Appointment appointment;

  final Function(int, int) rateAppointment;
  AppointmentCard({Key? key, required this.appointment, required this.userId,
    required this.rateAppointment}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool hasRated = false;

  @override
  Widget build(BuildContext context) {
    bool isPending = this.widget.appointment.status.toLowerCase() == "pending";
    bool isComplete = this.widget.appointment.status.toLowerCase() == "complete";
    String formattedDate = this.widget.appointment.bookingDate.split('-').map((part) {
      return part.padLeft(2, '0'); // Ensure two digits for each part
    }).join('-');
    DateTime bookingDateTime = DateTime.parse(formattedDate);
    Duration difference = bookingDateTime.difference(DateTime.now());

    bool canCheckIn = this.widget.appointment.status.toLowerCase() == "Waiting"
        && difference <= Duration(minutes: 30);

    //bool hasRated = widget.appointment.serviceRate != null;

      return Card(
        color: Colors.white,
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    this.widget.appointment.serviceType,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
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
                        this.widget.appointment.bookingDate,
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
                        this.widget.appointment.bookingTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (isPending)
                    ElevatedButton(
                      onPressed: () {

                        OneSignalController notify = OneSignalController();

                        List<String> targetUser = [];
                        targetUser.add(widget.userId.toString());
                        print("UserID: $targetUser");
                        notify.sendNotification("Check-In", "You have successfully check-in", targetUser);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessBookingPage(
                              appointmentId: widget.appointment.appointmentId,
                              bookingDate: bookingDateTime,
                              bookingTime: widget.appointment.bookingTime.toString(),
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple[50],
                      ),
                      child: Text('Check-In'),
                    ),
                if(isComplete)
                  Row(
                    children: [
                      if (!hasRated)
                        ElevatedButton(
                          onPressed: () {
                          // Show a pop-up dialog when the "Rate Service" button is pressed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("Service Satisfied"),
                              content: RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 30,
                                itemBuilder: (context, index) {
                              switch (index) {
                                  case 0:
                                  return const Icon(Icons.sentiment_very_dissatisfied,
                                  color: Colors.red);
                                  case 1:
                                  return const Icon(Icons.sentiment_satisfied,
                                  color: Colors.orange);
                                  case 2:
                                  return const Icon(Icons.sentiment_neutral,
                                  color: Colors.amber);
                                  case 3:
                                  return const Icon(Icons.sentiment_satisfied_sharp,
                                  color: Colors.blueAccent);
                                  case 4:
                                  return const Icon(Icons.sentiment_very_satisfied_outlined,
                                  color: Colors.green);
                                  default:
                                  return const Text("");
                                 }
                              },
                              onRatingUpdate: (rating) {
                              // Handle the rating update
                               print(rating);
                                widget.rateAppointment(widget.appointment.appointmentId, rating.toInt());
                                Navigator.of(context).pop(); // Close the dialog
                                    setState(() {
                                       hasRated = true; // Update the hasRated variable
                                    });
                              },
                              ),
                              );
                          },
                            );
                            },
                              style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple[50],
                            ),
                               child: Text('Rate Service'),
                            ),
                      if (hasRated)
                        Row(
                          children: [
                            Text(
                              'Your Rating: ${widget.appointment.serviceRate}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ]
            )
            )
      );

  }
}