import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class SignupPage extends StatelessWidget {

  // Each 1 textfield must have 1 TextEdittingController() !
  TextEditingController emailEdittingController = TextEditingController();
  TextEditingController icEdittingController = TextEditingController();
  TextEditingController nameEdittingController = TextEditingController();
  TextEditingController phoneEdittingController = TextEditingController();
  TextEditingController passwordEdittingController = TextEditingController();
  TextEditingController heightEdittingController = TextEditingController();
  TextEditingController weightEdittingController = TextEditingController();
  TextEditingController genderEdittingController = TextEditingController();

  String url = "http://10.131.75.185/pkums/patient/signup";

  //Patient patient = Patient(0, "", "", "", "", "", "", 0.0, 0.0);

  Future register() async{
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {
              "email": emailEdittingController.text,
              "password": passwordEdittingController.text,
              "ic": icEdittingController.text,
              "phone": phoneEdittingController.text,
              "name": nameEdittingController.text,
            }
        )
    );

    if(emailEdittingController.text.endsWith('@student.utem.edu.my') ||
        emailEdittingController.text.endsWith('@utem.edu.my')){
      print(response.body);
      try{
        if(response.statusCode == 200 ){
          Fluttertoast.showToast(
            msg: "Successful registered!",
            backgroundColor: Colors.white,
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0,
          );
        }
      }catch(e){
        print("Error: $e");
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again later.",
          backgroundColor: Colors.white,
          textColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0,
        );
      }
    }else{
      Fluttertoast.showToast(
        msg: "Invalid email",
        backgroundColor: Colors.white,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0,
      );
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color:Colors.black),),
              const SizedBox(height: 10),
              Text(
                "Create your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.black54),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your name"),
                  controller: nameEdittingController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.black54),
                        borderRadius: BorderRadius.circular(50.0),

                      ),
                      prefixIcon: const Icon(Icons.perm_identity),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your ic"),
                  controller: icEdittingController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.black54),
                        borderRadius: BorderRadius.circular(50.0),

                      ),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your email"),
                  controller: emailEdittingController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.black54),
                        borderRadius: BorderRadius.circular(50.0),

                      ),
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your phone"),
                  controller: phoneEdittingController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.black54),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your password"),
                  controller: passwordEdittingController,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple[100]),
                      ),
                      onPressed: (){
                        register();
                      }, child: const Text("Register")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




