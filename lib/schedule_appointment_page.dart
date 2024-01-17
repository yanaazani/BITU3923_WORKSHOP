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

enum FilterStatus { pending, waiting, complete, cancel }

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  late int userId;
  FilterStatus status_bar = FilterStatus.pending;
  List<Appointment> appointments = [];
  late FilterStatus status = FilterStatus.pending;
  //late FilterStatus status;
  List<Widget> tabPages = [];
  late Future<List<Appointment>> appointmentsFuture;

  Future<List<Appointment>> getAppointmentsByStatusAndUser(String status) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.131.75.185:8080/pkums/appointment/getstatus/$status/patient/$userId'),
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

  Future<void> rateAppointment(int appointmentId, int rating) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.131.75.185:8080/pkums/appointment/updateservicerate'
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
    status = status_bar;
    print(userId);
    appointmentsFuture = getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
    //getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: FilterStatus.values.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[100],
          title: Text("Schedule"),
          bottom: TabBar(
            tabs: FilterStatus.values.map((filter) {
              return Tab(text: filter.toString().split('.').last);
            }).toList(),
            onTap: (index) {
              setState(() {
                status_bar = FilterStatus.values[index];
                getAppointmentsByStatusAndUser(status_bar.toString().split('.').last);
              });
            },
          ),
        ),
        body: FutureBuilder(
          future: appointmentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return buildAppointmentList(status);
            }
          },
        ),
      ),
    );
  }

  Widget buildAppointmentList(FilterStatus status) {
    return appointments.isNotEmpty && appointments.any((appointment) {
      DateTime bookingDateTime = DateTime.parse(appointment.bookingDate.split('-').map((part) {
        return part.padLeft(2, '0'); // Ensure two digits for each part
      }).join('-'));
      DateTime currentDate = DateTime.now();
      return bookingDateTime.isAfter(currentDate) || bookingDateTime.day == currentDate.day;
    }) ? ListView.builder(
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
            rateAppointment: rateAppointment,
            status: status_bar
          );
        } else {
          return SizedBox(); // Return an empty container if not meeting the condition
        }
      },
    ) : Center(child: Text('No Appointments'));
  }
}


class AppointmentCard extends StatefulWidget {
  late final int userId;
  final Appointment appointment;
  final Function(int, int) rateAppointment;
  final FilterStatus status;
  AppointmentCard({Key? key, required this.appointment, required this.userId,
    required this.status,
    required this.rateAppointment}) : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool? isPending;
  bool hasRated = false;

  Future<void> checkInEnable (DateTime dates) async{
    DateTime bookingRealTime = DateTime.now();
    DateTime bookingRealDate = DateTime(bookingRealTime.year, bookingRealTime.month, bookingRealTime.day);
    DateTime currentTime = DateTime(bookingRealTime.year, bookingRealTime.month, bookingRealTime.day, bookingRealTime.hour, bookingRealTime.minute, bookingRealTime.second);

    // Convert the date without time to a string
    String formattedDateWithoutTime = "${bookingRealDate.year}-${bookingRealDate.month}-${bookingRealDate.day}";

    /**
     * Current Real time
     */
    print("--------------------------------------");
    print("Booking Date Time: ${dates}");
    print("Booking Real DateTime: ${bookingRealTime}");
    print("Booking Real Date: ${formattedDateWithoutTime}");
    String time = "${currentTime.hour}:${currentTime.minute}";
    print("Current time: $time");

    /**
     * Convert to string
     */

    /**
     * Appointment Date time
     */
    print("Booking Date: ${this.widget.appointment.bookingDate}");
    print("Booking Time: ${this.widget.appointment.bookingTime}");

    // Extracting hours and minutes from bookingTime
    List<String> bookingTimeParts = this.widget.appointment.bookingTime.replaceAll(RegExp(r'[^\d:]'), '').split(':');
    int bookingHours = int.parse(bookingTimeParts[0]);
    int bookingMinutes = int.parse(bookingTimeParts[1]);

    // Constructing a DateTime object with the booking time
    DateTime bookingTime = DateTime(bookingRealTime.year, bookingRealTime.month, bookingRealTime.day, bookingHours, bookingMinutes);

    // Calculate the time difference
    Duration timeDifference = bookingTime.difference(currentTime);


    // Print the time difference
    print("Time Difference: ${timeDifference.inHours} hours and ${timeDifference.inMinutes.remainder(60)} minutes");

    // Remove AM/PM from bookingTime
    String bookingTimeWithoutAMPM = this.widget.appointment.bookingTime.replaceAll(RegExp(r'[^\d:]'), '');

    print("Booking Time without AM/PM: $bookingTimeWithoutAMPM");

    if(timeDifference.inHours < 1 && timeDifference.inHours >= 0
        && timeDifference.inMinutes >= 0  && timeDifference.inMinutes <= 30
        && this.widget.appointment.status == "Pending"
        && this.widget.appointment.bookingDate == formattedDateWithoutTime
    ){
      setState(() {
        isPending = true;
      });
    }



  }


  @override
  Widget build(BuildContext context) {
    //bool isPending = this.widget.appointment.status == "Pending";
    bool isComplete = this.widget.appointment.status.toLowerCase() == "complete";

    String formattedDate = this.widget.appointment.bookingDate.split('-').map((part) {
      return part.padLeft(2, '0'); // Ensure two digits for each part
    }).join('-');

    DateTime bookingDateTime = DateTime.parse(formattedDate);

    checkInEnable(bookingDateTime);

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
            if (isPending == true)
              ElevatedButton(
                onPressed: () {
                  OneSignalController notify = OneSignalController();
                  List<String> targetUser = [];
                  targetUser.add(widget.userId.toString());
                  notify.sendNotification("Check In", "Check In successfully", targetUser);

                  //Navigator.push(context, MaterialPageRoute(builder: (Context) => SuccessBookingPage(appointment.appointmentId, appointment.bookingDate, appointmnet.bookingTime.toString(), userId)));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessBookingPage(
                        appointmentId: widget.appointment.appointmentId,
                        bookingDate: bookingDateTime,
                        bookingTime: widget.appointment.bookingTime.toString(),
                        userId: widget.userId,
                        status: widget.status.toString().split('.').last,
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


