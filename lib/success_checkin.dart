import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-in Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Lottie.network(
                "https://lottie.host/f21e84ce-0595-4141-ade4-1ea2593adb5d/Ewjyb6fP00.json",
                animate: true,
              ),
            ),
            SizedBox(height: 8),
            Text('Check-in Successful'),
          ],
        ),
      ),
    );
  }
}
