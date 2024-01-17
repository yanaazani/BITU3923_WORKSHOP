
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ui/forgot_pasword.dart';
import 'menu_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Patient {

  String email = "";
  String password = "";
  Patient( this.email, this.password);

  Patient.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    password = json["password"];
  }

  String get _Email => email;
  set _Email(String value) => email = value;

  String get _password => password;
  set _password(String value) => password = value;
}

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  /**
   * Variables
   * 1. _password -> for Show/Hide password
   */
  bool _password = true;

  /**
   * This is the function to show and hide password
   */
  void togglePassword()
  {
    setState(() {
      _password = !_password;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String url = "http://10.131.75.185:8080/pkums/patient/login";
  //String url = "http://10.131.78.208:8080/pkums/patient/login";

  Patient patient = Patient("", "");

  Future loginHomepage() async{
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {
              "email": emailController.text,
              "password": passwordController.text,
            }
        )
    );

    if(emailController.text.endsWith('@student.utem.edu.my') ||
        emailController.text.endsWith('@utem.edu.my') ){
      try{
        if(response.statusCode == 200 ){
          Map<String, dynamic> responseData = json.decode(response.body);
          int userId = responseData["id"] as int;
          String userName = responseData["name"] as String;
          print("This is username: $userName");
          print("This is user id: $userId");

          Fluttertoast.showToast(
            msg: "Successful login!",
            backgroundColor: Colors.white,
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0,
          );

          OneSignal.login(userId.toString());

          Future.delayed(const Duration(seconds: 1), () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuPage(userId: userId)),
            );
          });

        }else {
          Fluttertoast.showToast(
            msg: "Invalid email or password.",
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
    }else {
      Fluttertoast.showToast(
        msg: "Invalid email or password.",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Column(
                children: [
                  Center(
                    child: Text("Log In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color:Colors.black),),
                  ),
                  Text("Welcome back!",
                    style: TextStyle(fontSize: 20),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/login.jpg", fit: BoxFit.cover,),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2,color: Colors.deepOrangeAccent
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white70,
                    hintText: "Enter your email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: togglePassword,
                        icon: Icon(_password ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2,color: Colors.deepOrangeAccent
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                      hintText: "Enter your password"),
                  // Hide text when _password is false
                  obscureText: !_password
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=>const ForgotPassword()),);
              },
              child: const Text(
                'Forgot Password?',
              ),
            ),
            SizedBox(
              width: 330,
              height: 50,
              child: TextButton(style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.deepPurple[100],
                padding: const EdgeInsets.all(10.0),
                textStyle: const TextStyle(fontSize: 20),),
                  onPressed: (){
                    loginHomepage();
                  }, child: const Text("Login")),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.deepPurple[100],
                padding: const EdgeInsets.all(10.0),
                textStyle: const TextStyle(fontSize: 20),),
                  onPressed: (){
                    loginHomepage();
                  }, child: Text("Login")),
            )*/
          ],
        ),
      ),



    );
  }
}
