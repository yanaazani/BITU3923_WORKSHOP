import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ui/feedback_others.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
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
            buildCheckItem("Login Trouble"),
            buildCheckItem("Repair Quality"),
            buildCheckItem("Speed and Efficiency"),
            buildCheckItem("Personal Profile"),
            //const SizedBox(height: 20.0),
            //buildFeedbackForm(),
            //const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: (){},
                  child:
                  const Text("Submit",
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    FeedbackOthersPage();
                  },
                  child: const Text("Others",
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)
                  ),
                )
              ],)
          ],
        ),

      ),
    );
  }
  buildCheckItem(title){
    return Padding(padding: const EdgeInsets.only(bottom: 1.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.deepPurple[200],),
          const SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[100],
            ),
          )
        ],
      ),
    );
  }

  buildFeedbackForm(){
    return Container(
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: Colors.grey),
                    ),
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
    );
  }

}
