import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  //String imageUrl = "assets/profilepic.png";
  late Uint8List? _images = Uint8List(0); // Default image URL


  ImagePicker picker = ImagePicker();
  File? _image;

  /// Get from gallery
  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        elevation: 2.0,
        centerTitle: true,
        title: const Text('Feedback',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Lottie.network("https://lottie.host/1bf323c9-4be4-4d8c-8654-53753e2cb550/rVAIOlx2HY.json"),
              ),
              //SizedBox(height: 10),
              const Text('Tell us what can be imrpoved?',
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black),),
              const SizedBox(
                height: 25.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.deepPurple[300],),
                      const SizedBox(width: 10.0),
                      Text(
                        "Login Trouble",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),),
                 Expanded(child: content(),),
                ],
              ),const SizedBox(width: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.deepPurple[300],),
                        const SizedBox(width: 10.0),
                        Text(
                          "Repair Quality",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),),
                  Expanded(child: content(),),
                ],
              ),const SizedBox(width: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.deepPurple[300],),
                        const SizedBox(width: 10.0),
                        Text(
                          "Efficiency",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),),
                  Expanded(child: content(),),
                ],
              ),const SizedBox(width: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.deepPurple[300],),
                        const SizedBox(width: 10.0),
                        Text(
                          "Personal Profile",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),),
                  Expanded(child: content(),),
                ],
              ),
              const SizedBox(
                height: 25.0,
              ),
              Container(
                height: 200.0,
                child: Stack(
                  children: [
                    TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Tell us on how can we improve...",
                        hintStyle: TextStyle(
                          fontSize: 13.0,
                          color: Colors.deepPurple[100],
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                width: 1.0,
                                color: Colors.white70,
                              )
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: IconButton(onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Upload Image",style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold, fontSize: 25,
                                    ),),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          _getFromGallery();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: Text("Gallery", style: GoogleFonts.poppins(
                                            fontSize: 15,
                                          ),),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }, icon: const Icon(Icons.add)),
                            ),
                            const SizedBox(width: 10.0,),
                            const Text("Upload Screenshot \n(Optional)",
                              style: TextStyle(color: Colors.grey),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){},
                      child:
                      const Text("Submit",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ],),
              )
            ],
          ),

        )

      ),
    );
  }
  Widget content(){
    return Row(
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30,
            itemBuilder: ( context, _)=> Icon(Icons.star,
            color: Colors.amber,
            ),
   onRatingUpdate: (rating) {
              print(rating);
            })
        ],
      );
  }

}
