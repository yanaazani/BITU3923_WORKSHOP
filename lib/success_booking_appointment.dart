import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/menu_page.dart';
import 'package:flutter/rendering.dart';

class SuccessBookingAppointmentPage extends StatefulWidget {
  final int appointmentId;
  final DateTime bookingDate;
  final String bookingTime;
  final int userId;

  SuccessBookingAppointmentPage({
    Key? key, required this.appointmentId,
    required this.bookingDate,
    required this.bookingTime,
    required this.userId,
  }) : super(key: key);

  @override
  State<SuccessBookingAppointmentPage> createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingAppointmentPage> {
  final GlobalKey _qrKey = GlobalKey();
  late String qrData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex:5,
              child: Lottie.network("https://lottie.host/f21e84ce-0595-4141-ade4-1ea2593adb5d/Ewjyb6fP00.json",
                animate: true,),),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('You are successfully booked',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 24),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepPurple[100],
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 16),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: widget.userId)),);
                  }, child: const Text("Back to Home Page")),)
          ],
        ),
      ),
    );
  }
}