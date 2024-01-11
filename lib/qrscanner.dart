import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrscan2/qrscan2.dart' as scanner;
import 'package:image_picker/image_picker.dart';

class QRScannerPage extends StatefulWidget {
  final int validateappointmentId;
  QRScannerPage({Key? key, required this.validateappointmentId}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState(
      validateappointmentId: validateappointmentId);
}

class _QRScannerPageState extends State<QRScannerPage> {

  late final int validateappointmentId;
  _QRScannerPageState({required this.validateappointmentId});

  String? result;
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanQRCodeFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final File imageFile = File(pickedFile.path);
        final List<int> bytes = await imageFile.readAsBytes();
        final Uint8List uint8List = Uint8List.fromList(bytes);
        final String data = await scanner.scanBytes(uint8List);

        // Extract JSON data from QR code
        Map<String, dynamic> jsonData = json.decode(data);

        // Validate data against backend
        bool isValid = await _validateQRData(jsonData);

        if (isValid) {
          // Update the appointment status if validation succeeds
          await _updateAppointment(jsonData);
        }

        setState(() {
          result = isValid ? 'Valid QR Code' : 'Invalid QR Code';
        });
      } catch (e) {
        print('Error scanning QR code from image: $e');
        setState(() {
          result = null;
        });
      }
    }
  }

  Future<bool> _validateQRData(Map<String, dynamic> data) async {
    try {
      // Prepare the API endpoint and request
      int appointmentId = data['appointmentId'];
      String date = data['bookingDate'];
      String time = data['bookingTime'];
      String status = data['status'];
      int patientId = data['patientId'];

      print('This is appointmentidpressed:$validateappointmentId');
      print('This is: $appointmentId, $date, $time, $status, $patientId');

      if (widget.validateappointmentId == appointmentId) {
        String apiUrl = 'http://10.131.73.214:8080/pkums/appointment/'
            'validateappointment/$appointmentId/$date/$time/$status/'
            'patient/$patientId';

        // Make the API call to validate the data
        http.Response response = await http.get(Uri.parse(apiUrl));

        // Check the response status and return validation result
        if (response.statusCode == 200) {
          print(response.body);
          if (response.body != null) {
            final jsonResponse = json.decode(response.body);
            if (jsonResponse != null && jsonResponse.isNotEmpty) {
              await _updateAppointment(
                  data); // Update appointment if validation succeeds
              return true;
            } else {
              print('ayoo null maa'); // Print statement added
              return false; // Body is empty or not valid, validation failed
            }
          } else {
            print('Response body is null');
            return false; // Body is null, validation failed
          }
        } else {
          throw Exception('The appointment is not in the database');
        }
      } else {
        print('Error: Appointment ID does not match');
        return false; // Appointment ID mismatch, validation failed
      }
    }
    catch
    (e) {
      print('Error validating QR data: $e');
      return false; // Validation failed
    }
  }

  Future<void> _updateAppointment(Map<String, dynamic> data) async {
    int appointmentId = data['appointmentId'];
    String newStatus = 'Waiting';

    // Prepare the API endpoint and request
    String apiUrl = 'http://10.131.73.214:8080/pkums/appointment'
        '/updateappointment/$appointmentId';

    // Make the API call to update the appointment status
    http.Response response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'status': newStatus}),
    );

    // Check the response status and handle accordingly
    if (response.statusCode == 200) {
      print('Appointment updated successfully');
    } else {
      print('Error updating appointment');
    }
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
            child: Center(
              child: ElevatedButton(
                onPressed: _scanQRCodeFromGallery,
                child: Text('Pick QR Code from Gallery'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned Data: $result')
                  : Text(''),
            ),
          ),
        ],
      ),
    );
  }
}