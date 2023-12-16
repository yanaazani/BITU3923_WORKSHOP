import 'package:flutter/material.dart';

class FeedbackOthersPage extends StatefulWidget {
  const FeedbackOthersPage({super.key});

  @override
  State<FeedbackOthersPage> createState() => _FeedbackOthersPageState();
}

class _FeedbackOthersPageState extends State<FeedbackOthersPage> {
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
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              buildFeedbackForm(),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: TextButton(style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.deepPurple[100],
                      padding: const EdgeInsets.all(10.0),
                      textStyle: const TextStyle(fontSize: 20),),
                        onPressed: (){

                        }, child: const Text("Submit")),)
                ],
              )
            ],
          ),
        )
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
