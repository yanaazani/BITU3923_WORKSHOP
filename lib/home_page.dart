import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui/feedback.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Yana Ezani",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,)
                  ),
                  SizedBox(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("assets/profilepic.png"),
                    ),
                  )
                ],
              ),
              //Category listing
              const Text("Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,)
              ),
              Expanded(
                child: MyButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  //const MyButton({super.key});

  List<Map<String, dynamic>> medCat = [
    {
      "icon": IconButton.filledTonal(
          iconSize: 40,
          onPressed: (){},
          icon: const Icon(Icons.public_rounded)),
      "category": "General",
    },
    {
      "icon": IconButton.filledTonal(
          iconSize: 40,
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>AppointmentPage()),);
          },
          icon: const Icon(Icons.local_hospital_outlined)),
      "category": "Appointment",
    },
    {
      "icon": IconButton.filledTonal(
          iconSize: 40,
          onPressed: (){},
          icon: const Icon(Icons.calendar_month_outlined)),
      "category": "Calendar",
    },
    {
      "icon": IconButton.filledTonal(
          iconSize: 40,
          onPressed: (){},
          icon: const Icon(Icons.person_2_outlined)),
      "category": "Profile",
    },
    {
      "icon": IconButton.filledTonal(
          iconSize: 40,
          onPressed: (){},
          icon: const Icon(Icons.feedback_outlined)),
      "category": "Feedbaack",
    },
  ];

  MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List<Widget>.generate(medCat.length, (index){
          return Card(
            margin: const EdgeInsets.only(right: 20),
            color: Colors.deepPurple[100],
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 1,
                    child: medCat[index]['icon'],
                  ),
                  Text(
                    medCat[index]['category'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        ),
      ),
    );
  }
}
