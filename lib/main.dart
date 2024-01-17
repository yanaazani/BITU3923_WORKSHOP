import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'sign_up.dart';
import 'qrscanner.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("3f32bf80-053a-4661-9e26-b37ccf08f370");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: null,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/pku.png", fit: BoxFit.cover),
            ),
            SizedBox(height: 20, width: 50.0),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.deepPurple[100],
                padding: const EdgeInsets.all(10.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: const Text('Log In'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.deepPurple[100],
                padding: const EdgeInsets.all(10.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text('Sign Up'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.deepPurple[100],
                padding: const EdgeInsets.all(10.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerPage()),
                );
              },
              child: const Text('Scan QR'),
            ),
          ],
        ),
      ),
    );
  }
}