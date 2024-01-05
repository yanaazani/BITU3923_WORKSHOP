import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/model/patient_model.dart';
import 'package:http/http.dart' as http;

import 'edit_profile.dart';
import 'main.dart';
import 'menu_page.dart';

class UserProfile extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const UserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}


class _UserProfileState extends State<UserProfile> {
  Patient? _patient;
  late final int userId;
  late Patient currentPatient;
  String name = "", email = "",
      phone = "", ic = "", password = "", gender = "";
  double weight = 0.0, height = 0.0;

  bool showLogoutText = false;
  bool isObsecurePassword = true;

  late TextEditingController  emailController = TextEditingController();
  late TextEditingController icController= TextEditingController();
  late TextEditingController nameController= TextEditingController();
  late TextEditingController phoneController= TextEditingController();
  late TextEditingController passwordController= TextEditingController();
  late TextEditingController heightController= TextEditingController();
  late TextEditingController weightController= TextEditingController();
  late TextEditingController genderController= TextEditingController();

  /**
   * Function to display account information
   * based on username passed from Login page
   */
  Future<void> getUser() async {
    final response = await http.get(Uri.parse('http://192.168.0.10:8080/pkums/patient/details/${widget.userId}'));
    if (response.statusCode == 200) {
      // Parse the JSON response into a `Patient` object.
      final patient = Patient.fromJson(jsonDecode(response.body));

      print(response.body);

      setState(() {
        _patient = patient;
        name = patient.name;
        email = patient.email;
        password = patient.password;
        ic = patient.ic;
        phone = patient.phone;
        height = parseDouble(patient.height);
        weight = parseDouble(patient.weight);
        gender = patient.gender;

        nameController.text = patient.name;
        emailController.text = patient.email;
        passwordController.text = patient.password;
        icController.text = patient.ic;
        phoneController.text = patient.phone;
        //heightController.text = patient.height as String;
        //weightController.text = patient.weight as String;
        heightController.text = patient.height.toString();
        weightController.text = patient.weight.toString();
        genderController.text = patient.gender;


      });
    } else {
      throw Exception('Failed to fetch patient');
    }
  }

  double parseDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      return 0.0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: Container(child: const Text("Profile Page"),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: widget.userId)),
            ); // Navigate back to the previous screen
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: ListView(
          children: [
            if (showLogoutText)
              Align(
                alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.deepPurple[200],
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          // Handle "Log out" logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                          );
                        },
                        child: const Text("Log out"),
                      ),
                    ],
                  ),
                ),
            Container(
              width: 130, height: 130, decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1)
                  ),
                ],
                shape: BoxShape.circle,
                image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/profilepic.png")
            )
            ),
            ),
            const SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
                elevation: 4,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.emoji_people),
                              const SizedBox(width: 10),
                            Text('$name',
                            style: const TextStyle(fontSize: 14,
                            color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
                ),
        ), // To display name
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.email_outlined),
                            const SizedBox(width: 10),
                            Text('$email',
                              style: const TextStyle(fontSize: 14,
                              color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // To display email
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.perm_identity),
                            const SizedBox(width: 10),
                            Text('$ic',
                              style: const TextStyle(fontSize: 14,
                                  color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // To display ic or passport number
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 10),
                            Text('$phone',
                              style: const TextStyle(fontSize: 14,
                              color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // To display phone number
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.transgender_outlined),
                            const SizedBox(width: 10),
                            Text('$gender',
                              style: const TextStyle(fontSize: 14,
                              color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // To display gender
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.height_outlined),
                            const SizedBox(width: 10),
                            Text('$height cm',
                              style: const TextStyle(fontSize: 14,
                              color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // To display height in cm
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(width: 2, color: Colors.deepPurple),
              ),
              elevation: 4,
              margin: const EdgeInsets.all(10),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.monitor_weight_outlined),
                            const SizedBox(width: 10),
                            Text('$weight kg',
                              style: const TextStyle(fontSize: 14,
                              color: Colors.black54),
                            ),
                          ]
                      ),
                    ],
                  )
              ),

            ), // to display weight in kg
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  ProfilePage(userId: widget.userId)),
              );
            }, child: const Text(
                "Edit", style: TextStyle(
                fontSize: 15, letterSpacing: 2, color: Colors.black)),
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)
              ),
            )
      ]
        )
    )
    );
  }
}
