import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'menu_page.dart';

class FeedbackPage extends StatefulWidget {
  final int userId;
  const FeedbackPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState(userId: userId);
}

class _FeedbackPageState extends State<FeedbackPage> {
   late final int userId;
  _FeedbackPageState({required this.userId});

  TextEditingController _commentController = TextEditingController();
  double rating = 0.0; // Declare the rating variable

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

  String url = "http://192.168.0.10:8080/pkums/feedback/add";
  Future<void> insertFeedback(double loginTroubleRating, double repairQualityRating,
      double  efficiencyRating,double personalProfileRating,
      String comment, int patient) async{

    final Uri uri = Uri.parse('http://192.168.0.10:8080/pkums/feedback/add');
    try{
      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
              {
                "loginTroubleRating": loginTroubleRating,
                "repairQualityRating": repairQualityRating,
                "efficiencyRating": efficiencyRating,
                "personalProfileRating": personalProfileRating,
                "comment": comment,
                "patientId": {
                  "id": patient
                }
              }
          )
      );
      if(response.statusCode == 200){
        Fluttertoast.showToast(
          msg: "Thank you for your feedback!",
          backgroundColor: Colors.white,
          textColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0,
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: userId)),
          );
        });
      } else {
        throw Exception('Failed to add feedback');
      }
    } catch (e) {
      print('Error: $e');
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
                      controller: _commentController,
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
                      onPressed: () async {
                        // Retrieve ratings from the RatingBar widget
                        double loginTroubleRating = getRating("Login Trouble", rating);
                        double repairQualityRating = getRating("Repair Quality", rating);
                        double efficiencyRating = getRating("Efficiency", rating);
                        double personalProfileRating = getRating("Personal Profile", rating);
                        // Retrieve comment from the text field
                        String comment = _commentController.text;

                        // Call the function to insert feedback
                        await insertFeedback(loginTroubleRating, repairQualityRating,
                          efficiencyRating, personalProfileRating, comment,
                          userId,);
                      },
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

  double getRating(String category, double rating) {
    switch (category) {
      case "Login Trouble":
      // Logic for handling "Login Trouble" rating
        return rating;
      case "Repair Quality":
      // Logic for handling "Repair Quality" rating
        return rating;
      case "Efficiency":
      // Logic for handling "Efficiency" rating
        return rating;
      case "Personal Profile":
      // Logic for handling "Personal Profile" rating
        return rating;
      default:
      // Handle the default case if the category is not recognized
        return 0.0;
    }
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
           onRatingUpdate: (double value) {
             rating = value;
             // Assuming you want to get the rating for "Login Trouble" option
             double loginTroubleRating = getRating("Login Trouble", rating);
             double repairQualityRating = getRating("Repair Quality", rating);
             double efficiencyRating = getRating("Repair Quality", rating);
             double personalProfileRating = getRating("Personal Profile", rating);

            })
        ],
      );
  }

}
