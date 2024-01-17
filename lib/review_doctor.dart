import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart' as FlutterRatingBar;

class ReviewPage extends StatefulWidget {
  final int userId;
  final int icDoctor;
  final String? doctorFirstName;
  final String? doctorLastName;
  final String? doctorEmail;

  ReviewPage({
    required this.doctorFirstName,
    required this.doctorLastName,
    required this.doctorEmail,
    required this.userId,
    required this.icDoctor ,
  });

  @override
  _ReviewPageState createState() => _ReviewPageState(userId: userId,
      icDoctor: icDoctor);
}

class _ReviewPageState extends State<ReviewPage> {
  late final int userId;
  _ReviewPageState({required this.userId,  required this.icDoctor,});
  TextEditingController reviewController = TextEditingController();
  double rating = 0.0;
  int filledStars = 0, doctor = 0, icDoctor = 0;

  Future<void> insertFeedback(double rating, String review,
      int patient, int icDoctor) async{

    final Uri uri = Uri.parse('http://10.131.75.185:8080/pkums/'
        'feedbackdoctor/insert');
    try{
      final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(
              {
                "rating": rating.toInt(),
                "review": review,
                "patientId": {
                  "id": patient
                },
                "icDoctor": {
                  "icDoctor": icDoctor
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
      } else {
        print('Error: Failed to add feedback. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to add feedback');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add feedback');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Give a Review'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/feedback.jpg", fit: BoxFit.cover,),
              ),
            ),
            Text(
              'Doctor: ${widget.doctorFirstName ?? ''} ${widget.doctorLastName ?? ''}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Rating:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            FlutterRatingBar.RatingBar.builder(
              initialRating: filledStars.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 40.0, // Set the custom icon size here
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                  filledStars = rating.toInt();
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Review:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Handle the logic for submitting the review
                // You can send the review and rating to your backend or perform any other actions
                String review = reviewController.text;
                // TODO: Implement logic to send the review and rating to your backend
                print('Rating: $rating, Review: $review');

                await insertFeedback(rating, review,
                     userId, icDoctor);

                // Close the review page
                Navigator.pop(context);
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      )
    );
  }
}

class RatingBar extends StatelessWidget {
  final IconData filledIcon;
  final IconData emptyIcon;
  final int filledCount;
  final double iconSize;
  final ValueChanged<double> onRatingChanged;

  RatingBar({
    required this.filledIcon,
    required this.emptyIcon,
    required this.filledCount,
    required this.onRatingChanged,
    this.iconSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            index < filledCount ? filledIcon : emptyIcon,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}
