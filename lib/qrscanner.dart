import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:ui/success_checkin.dart';
import 'package:vibration/vibration.dart';

import 'fail_checkin.dart';

class QRScannerPage extends StatefulWidget {
  QRScannerPage({Key? key}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? result;
  bool isProcessing = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      try {
        if (!isProcessing) {
          setState(() {
            isProcessing = true;
          });

          Map<String, dynamic> jsonData = {};

          if (scanData.code != null) {
            try {
              jsonData = json.decode(scanData.code!);
            } catch (e) {
              print('Error decoding QR code content: $e');
            }
          }

          bool isValid = await _validateQRData(jsonData);

          if (isValid) {
            await _updateAppointment(jsonData);
            _navigateToSuccessPage();
          } else {
            _navigateToErrorPage();
          }

          Vibration.vibrate(duration: 500);

          setState(() {
            result = isValid ? 'Valid QR Code' : 'Invalid QR Code';
            isProcessing = false;
          });
        }
      } catch (e) {
        print('Error scanning QR code: $e');
        setState(() {
          result = null;
          isProcessing = false;
        });
      }
    });
  }

  Future<bool> _validateQRData(Map<String, dynamic> data) async {
    int appointmentId = data['appointmentId'];
    String date = data['bookingDate'];
    String time = data['bookingTime'];
    String status = data['status'];
    int userId = data['userId'];

    String apiUrl =
        'http://10.131.75.185:8080/pkums/appointment/validateappointment'
        '/$appointmentId/$date/$time/$status/patient/$userId';

    http.Response response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      if (response.body != null) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse != null && jsonResponse.isNotEmpty) {
          await _updateAppointment(data);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      throw Exception('The appointment is not in the database');
    }
  }

  Future<void> _updateAppointment(Map<String, dynamic> data) async {
    int appointmentId = data['appointmentId'];
    String newStatus = 'Waiting';
    String apiUrl =
        'http://10.131.75.185:8080/pkums/appointment/updateappointment/$appointmentId';

    http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'status': newStatus}),
    );

    if (response.statusCode != 200) {
      print('Error updating appointment');
    }
  }

  void _navigateToSuccessPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SuccessPage()),
    );
  }

  void _navigateToErrorPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ErrorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null) ? Text('Scanned Data: $result') : Text(''),
            ),
          ),
        ],
      ),
    );
  }
}
