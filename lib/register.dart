/**import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';

class Patient {
  int patientId = 0;
  String email = "";
  String ic = "";
  String name = "";
  String phone = "";
  String password = "";
  double height = 0.0;
  String gender = "";
  double weight = 0.0;

  Patient(this.patientId, this.email, this.ic, this.name,
      this.phone, this.password, this.gender, this.height, this.weight);

  Patient.fromJson(Map<String, dynamic> json) {
    patientId = json["id"];
    email = json["email"];
    name = json["name"];
    ic = json["ic"];
    phone = json["phone"];
    password = json["password"];
    gender = json["gender"];
    height = json["height"];
    weight = json["weight"];
  }

  int get _Id => patientId;
  set _Id(int value) => patientId = value;

  String get _ic => ic;
  set _ic(String value) => ic = value;


  String get _name => name;
  set _name(String value) => name = value;

  String get _Email => email;
  set _Email(String value) => email = value;

  String get _password => password;
  set _password(String value) => password = value;

  String get _phone => phone;
  set _phone(String value) => phone = value;

  double get _weight => weight;
  set _weight(double value) => weight = value;

  double get _height => height;
  set _height(double value) => height = value;

  String get _gender => gender;
  set _gender(String value) => gender = value;
}

abstract class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // Each 1 textfield must have 1 TextEdittingController() !
  TextEditingController emailEdittingController = TextEditingController();
  TextEditingController icEdittingController = TextEditingController();
  TextEditingController nameEdittingController = TextEditingController();
  TextEditingController phoneEdittingController = TextEditingController();
  TextEditingController passwordEdittingController = TextEditingController();
  TextEditingController birthdayEdittingController = TextEditingController();
  TextEditingController heightEdittingController = TextEditingController();
  TextEditingController weightEdittingController = TextEditingController();
  TextEditingController genderEdittingController = TextEditingController();

  //String url = "http://10.0.3.2:8080/pkums/patient/signup";
  String url = "http://192.168.0.10:8080/pkums/patient/signup";

  Patient patient = Patient(0, "", "", "", "", "", "", 0.0, 0.0);

  Future signup() async{
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {
              "email": emailEdittingController.text,
              "password": passwordEdittingController.text,
              "ic": icEdittingController.text,
              "phone": phoneEdittingController.text,
              "name": nameEdittingController.text,
              //"gender": genderEdittingController.text,
              //"height": heightEdittingController.text,
              //"weight": weightEdittingController.text,
            }
        )
    );

    if(emailEdittingController.text.endsWith('@student.utem.edu.my') ||
        emailEdittingController.text.endsWith('@utem.edu.my') ){
      try{
        if(response.statusCode == 200){
          Fluttertoast.showToast(
            msg: "Successful registered!",
            backgroundColor: Colors.white,
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0,
          );
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Login()),
            );
          });
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
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(backgroundColor: Colors.deepPurple[100],),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 32, color:Colors.black),),
              ),
              // 2) Link the Controller to the textfeald
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextFormField(
                          controller: emailEdittingController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.deepOrangeAccent),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              prefixIcon: const Icon(Icons.person_outline),
                              hintText: "bxxxxxxxxx@student.utem.edu.my") ,
                          //: emailEdittingController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: icEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "xxxxxx-xx-xxxx"),
                          //controller: icEdittingController,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: nameEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "as in IC"),
                          //controller: nameEdittingController,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: phoneEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "xxx-xxxxxxx"),
                          //controller: phoneEdittingController,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: genderEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "F = Female // M = Male"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: heightEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "cm"),
                          //controller: passwordEdittingController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: weightEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "kg"),
                          //controller: passwordEdittingController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: TextField(
                          controller: passwordEdittingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(20.0),),
                              filled: true,
                              fillColor: Colors.white70,
                              hintText: "Must be 8 characters"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white70,
                    padding: const EdgeInsets.all(10.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: (){
                    signup();

                  }, child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
**/