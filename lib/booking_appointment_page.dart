import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ui/model/appointment_model.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ui/success_booking_appointment.dart';

class BookingPage extends StatefulWidget {
  final int userId;
  BookingPage({Key? key, required this.userId,}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState(userId: userId);
}


class _BookingPageState extends State<BookingPage> {
  late final int userId;
  _BookingPageState({required this.userId});



  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  String _selectedServiceType = 'Regular Checkup'; // Default selected service type

  //List<String> _serviceType = ['Regular Checkup', 'Dental Checkup'];


  /**
   * General steps to implement REST API for front-end:
   * 1. define your localhost
   *    - if at Android Virtual Device (in Android Studio) emulator (for Spring-boot as backend), use 10.0.2.2
   *    - if using php as backend, change the localhost based on network WIFI (ipconfig at cmd -> ipv4 for wifi ethernet)
   * 2. generate backend like learnt in DAD subject
   *    -> create model class, make sure the casing for each attribute, getter and setter is correct
   *    -> repository (if got custom SQL query needed, create method definition)
   *    -> controller, then define the API for the method in controller (set type of mapping -> GET,POST, PUT, DELETE)
   * 3. construct frontend method
   *    -> using Future<void/ return type -> basically for future.builder>, then async(){}
   *    -> then await http.get.post/put/delete
   *    -> Uri.parse("your backend api")
   *    -> get response result, response status code (200 means OK)
   *    -> setstate for refresh the UI
   * 4. Implement the front-end method to the UI by calling the method.
   */
  late List<Appointment> specificAppointment = [];

  Future<void> validateAppointment(String date, String time, String status,
      String serviceType, int patient, int room) async {
    final response = await http.get(Uri.parse(
      'http://10.131.75.185:8080/pkums/appointment/getappointment/$date/$time',
    ));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        specificAppointment = data.map((json) =>
            Appointment.fromJson(json)).toList();
      });

      if (specificAppointment.length >= 3) {
        Fluttertoast.showToast(
          msg: 'Sorry, the slot: $time on $date is full!',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0,
        );
      } else {
        bool isAM = int.parse(time.split(':')[0]) < 12;
        //String likePM = "PM";

        final responseAM = await http.get(Uri.parse(
          'http://10.131.75.185:8080/pkums/appointment/validateappointmentAM/patient/$patient/$date',
        ));

        final responsePM = await http.get(Uri.parse(
          'http://10.131.75.185:8080/pkums/appointment/validateappointmentPM/patient/$patient/$date',
        ));

        print(responseAM.body);
        print(responsePM.body);
        print(isAM);

        if (isAM) {
          if (responseAM.statusCode == 200 && jsonDecode(responseAM.body).isNotEmpty) {
            Fluttertoast.showToast(
              msg: 'Cannot book AM slot on $date as it already exists!',
              backgroundColor: Colors.white,
              textColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 16.0,
            );
          } else {
            insertAppointment(date, time, status, serviceType, patient, room);
          }
        } else {
          if (responsePM.statusCode == 200 && jsonDecode(responsePM.body).isNotEmpty) {
            Fluttertoast.showToast(
              msg: 'Cannot book PM slot on $date as it already exists!',
              backgroundColor: Colors.white,
              textColor: Colors.red,
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 16.0,
            );
          } else {
            insertAppointment(date, time, status, serviceType, patient, room);
          }
        }
      }
    } else {
      throw Exception('Failed to fetch job');
    }
  }




  /**
   * Method implementation for add appointment slot
   * only if the current slot available is less than or equal to 3
   */

  Future<void> insertAppointment(String? bookingDate, String? bookingTime,
      String? status, String? serviceType, int? patient, int? room) async {
    final Uri uri = Uri.parse('http://10.131.75.185:8080/pkums/appointment/insertappointment');

    try {
      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
              {
                'bookingDate': bookingDate,
                'bookingTime': bookingTime,
                'status': status,
                'serviceType': serviceType,
                "patientId": {
                  "id": patient
                },
                "roomId": {
                  "id": room
                }
              }
          )
      );

      print(response.body);

      if (response.statusCode == 200) {
        // Assuming the response body contains the appointment ID
        Map<String, dynamic> responseData = json.decode(response.body);
        int appointmentId = responseData["id"];
        var dateParts = responseData["bookingDate"].split('-');
        var year = int.parse(dateParts[0]);
        var month = dateParts[1].padLeft(2, '0'); // Ensure two digits for month
        var day = dateParts[2].padLeft(2, '0');   // Ensure two digits for day

        var parsedBookingDate = DateTime.parse('$year-$month-$day');
        var bookingTimeString = responseData["bookingTime"];
        print(appointmentId);

        // Navigate to the success page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessBookingAppointmentPage(
              userId: userId,
              appointmentId: appointmentId,
              bookingDate: parsedBookingDate,
              bookingTime: bookingTime.toString(),
            ),
          ),
        );
      } else {
        throw Exception('Failed to add appointment');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    //Config().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Appointment"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                //   child: Text(
                //     "Select Service Type",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(bottom: 25),
                //   child: DropdownButton<String>(
                //     value: _selectedServiceType,
                //     icon: Icon(Icons.arrow_downward),
                //     iconSize: 24,
                //     elevation: 16,
                //     style: TextStyle(color: Colors.deepPurple),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         _selectedServiceType = newValue ?? '';
                //       });
                //     },
                //     items: _serviceType.map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: value,
                //         child: Text(value),
                //       );
                //     }).toList(),
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5),
                  child: Text("Select Consultation Date",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
                //Display table calendar
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 25),
                  child: Text("Select Consultation Time",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
              ],
            ),
          ),
          _isWeekend ? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              alignment: Alignment.center,
              child: const Text('Weekend is not available, \nplease select another date.',
                style: TextStyle(
                  fontWeight: FontWeight.bold ,
                  fontSize: 15,
                  color: Colors.grey,
                ),),
            ),
          )
              : SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index){
              return InkWell(
                splashColor: Colors.transparent,
                onTap: (){
                  //when selected, update current index and set time selcted
                  // to true
                  setState(() {
                    _currentIndex = index;
                    _timeSelected = true;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: _currentIndex == index
                        ? Colors.deepPurple[100]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: /*Text(
                    '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',*/
                  Text(
                    '${(index + 9).toString().padLeft(2, '0')}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold ,
                      fontSize: 15,
                      color: _currentIndex == index ? Colors.white : null,
                    ),
                  ),
                ),
              );
            },
                childCount: 8
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepPurple[100],
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 20),),
                  onPressed: () async {
                    if (_dateSelected && _timeSelected) {
                      int? currentHour;
                      currentHour = _currentIndex ?? 0;
                      DateTime selectedDate = DateTime(
                          _currentDay.year,
                          _currentDay.month,
                          _currentDay.day // Assuming your time starts from 9 AM
                      );

                      // Now, 'selectedDateTime' contains both date and time

                      // Example: Print the selected date and time

                      // date: 2023-12-5 -> day: 5 < 10 -> display: 2023-12-05 (not 2023-12-5)
                      // date: 2023-12-15 -> day: 15 > 10 -> display: 2023-12-15

                      String dateSelect = "${_currentDay.year}-${_currentDay.month}"
                          "-${_currentDay.day.toString().padLeft(2, '0')}";

                      // time: 1.00 -> 1+9 = 10 <= 11 -> display as: 10.00AM
                      // time: 4.00 -> 4+9 = 13 > 11 -> display as: 13.00PM
                      String timeSelect = "${(currentHour + 9).toString().padLeft(2, '0')}:00${currentHour +
                          9 > 11 ? "PM" : "AM"}";


                      print("Selected date: $dateSelect");
                      print("Selected time: $timeSelect");
                      await validateAppointment(dateSelect, timeSelect,
                          "Pending", _selectedServiceType, userId, 1);


                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const SuccessBookingPage()),);
                  }, child: const Text("Make Appointment")),
            ),
          )
        ],
      ),
    );
  }

  /**
   * Method to call out calendar widget
   */
  Widget _tableCalendar(){
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime.now(),
      lastDay: DateTime(2024,12,30),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration:
        BoxDecoration(
            color: Colors.deepPurple, shape: BoxShape.circle),
      ),
      availableCalendarFormats: const{
        CalendarFormat.month: 'Month',
      },
      onFormatChanged: (format){
        setState(() {
          _format = format;
        });
      },
      onDaySelected:((selectedDay, focusedDay){
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          // to check if the weekend is selected
          if(selectedDay.weekday == 6 || selectedDay.weekday == 7){
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          }else{
            _isWeekend = false;
          }
        });
      }),
    );
  }
}