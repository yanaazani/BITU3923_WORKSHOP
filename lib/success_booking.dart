import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui/menu_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'permission.dart';
import 'package:path/path.dart';


class SuccessBookingPage extends StatefulWidget {
  final int userId;
  final String appointmentId;
  final DateTime bookingDate;
  final String bookingTime;

  //String qrData = createQRData(userId, appointmentId, bookingDate, bookingTime);

  SuccessBookingPage({
    Key? key, required this.userId,
    required this.appointmentId,
    required this.bookingDate,
    required this.bookingTime
  }) : super(key: key);

  @override
  State<SuccessBookingPage> createState() => _SuccessBookingPageState();
}

class _SuccessBookingPageState extends State<SuccessBookingPage> {
  final GlobalKey _qrKey = GlobalKey();
  late String qrData;
  bool dirExists = false;
  // /storage/emulated/0 : main directory of the file explorers
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';

  Future<void> _captureAndSavePng() async {
    try{
      RenderRepaintBoundary boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,Rect.fromLTWH(0,0,image.width.toDouble(),image.height.toDouble()));
      canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code';
      int i = 1;
      while(await File('$externalDir/$fileName.png').exists()){
        fileName = 'qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not
      dirExists = await File(externalDir).exists();
      //if not then create the path
      if(!dirExists){
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if(!mounted)return;
      Fluttertoast.showToast(
          msg: 'Saved to gallery to directory $externalDir/$fileName.png',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0
      );

    }catch(e){
      if(!mounted)return;
      const snackBar = SnackBar(content: Text('Something went wrong!!!'));
      Fluttertoast.showToast(
          msg: 'Something went wrong!',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0
      );
    }
  }

  @override
  void initState() {
    super.initState();
    qrData = createQRData(widget.userId, widget.appointmentId, widget.bookingDate, widget.bookingTime);
  }

  String createQRData(int userId, String appointmentId, DateTime bookingDate, String bookingTime) {
    Map<String, dynamic> data = {
      'userId': userId,
      'appointmentId': appointmentId,
      'bookingDate': "${bookingDate.year}-${bookingDate.month}-${bookingDate.day}",
      'bookingTime': bookingTime
    };
    return jsonEncode(data);
  }


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
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text('Successfully Booked',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            const Spacer(),
            // QR Code section with added functionality to save
            RepaintBoundary(
              key: _qrKey,
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.deepPurple[100],
                  padding: const EdgeInsets.all(10.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: _captureAndSavePng,
                child: const Text("Save QR Code"),
              ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.deepPurple[100],
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 20),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: widget.userId)),);
                  }, child: const Text("Back to Home Page")),)
          ],
        ),
      ),
    );
  }
}