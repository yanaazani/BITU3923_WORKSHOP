import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/menu_page.dart';

class SuccessBookingPage extends StatelessWidget {
  final int userId;
  const SuccessBookingPage({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple[100],),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex:5,
              child: Lottie.network("https://lottie.host/f21e84ce-0595-4141-ade4-1ea2593adb5d/Ewjyb6fP00.json",
                animate: true,),),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Successfully Booked',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            const Spacer(),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepPurple[100],
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: userId)),);
                  }, child: const Text("Back to Home Page")),)
          ],
        ),
      ),
    );
  }
}
