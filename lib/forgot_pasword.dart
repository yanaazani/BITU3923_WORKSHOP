import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ui/main.dart';
import 'package:flutter/material.dart';
import 'package:ui/model/patient_model.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "", newPassword = "";
  late TextEditingController  emailController = TextEditingController();
  late TextEditingController passwordController1= TextEditingController();
  late TextEditingController passwordController2= TextEditingController();
  bool _password = true;

  void togglePassword() {
    setState(() {
      _password = !_password;
    });
  }

  Future<void> resetPassword(String email) async {
    try {
      final response = await http.get(Uri.parse('http://10.131.75.185:8080/pkums'
          '/patient/email/$email'));

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        if (responseData != null && responseData['email'] != null) {
          // Handle the case where email is not null
          setState(() {
            email = responseData['email'];
            emailController.text = email;
          });
          showResetPasswordDialog();
        } else {
          // Handle the case where email is null or not available
          Fluttertoast.showToast(
            msg: "Email not found",
            backgroundColor: Colors.white,
            textColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0,
          );
        }
      } else {
        throw Exception('Failed to fetch patient.'
            ' Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: "Invalid email ",
        backgroundColor: Colors.white,
        textColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0,
      );
      // Handle error, you might want to show an error message to the user
    }
  }
  Future<void> updatePassword(String email, String newPassword) async{
    try {
      final response = await http.put(
        Uri.parse('http://10.131.75.185:8080/pkums/patient/updatepassword/$email'),
        body: jsonEncode({'password': newPassword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Password updated successfully
        print('Password updated successfully');
      } else {
        throw Exception(
            'Failed to update password. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, you might want to show an error message to the user
    }
  }

  void showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Text('Enter your new password:'),
                ],
              ),
              TextField(
                    controller: passwordController1,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: togglePassword,
                          icon: Icon(_password ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "New password"),
                    // Hide text when _password is false
                    obscureText: !_password
                ),
              TextField(
                controller: passwordController2,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: togglePassword,
                        icon: Icon(_password ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      hintText: "Re-enter new password"),
                  // Hide text when _password is false
                  obscureText: !_password
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
               /** newPassword = passwordController.text;
                updatePassword(email, newPassword);
                // After resetting, you may want to show a success message
                Navigator.of(context).pop(); // Close the dialog
                showPasswordResetSuccessDialog();**/
                if (passwordController1.text == passwordController2.text) {
                  // Passwords match, proceed with the update
                  newPassword = passwordController1.text;
                  updatePassword(email, newPassword);
                  Navigator.of(context).pop(); // Close the dialog
                  showPasswordResetSuccessDialog();
                } else {
                  // Passwords do not match, show an error message
                  Fluttertoast.showToast(
                    msg: "Passwords do not match",
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    toastLength: Toast.LENGTH_LONG,
                    fontSize: 16.0,
                  );
                }

              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void showPasswordResetSuccessDialog() {
    // Implement a dialog to show the success message
    // You can customize this based on your requirements
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Reset Successful'),
          content: const Text('Your password has been reset successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resetPassword(emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
                  width: 30,
                ),
                const Center(
                  child: Text("Trouble with \nlogging in?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color:Colors.black),),
                ),
                const Padding(padding: EdgeInsets.all(8.0),),
                const Center(
                  child: Text("Enter your email and wait \n"
                      "for a while for the process.",
                    style: TextStyle(fontSize: 15),),
                ),
                const Padding(padding: EdgeInsets.all(8.0),),
                Image.asset(
                  'assets/forgot.png',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      TextButton.icon(
                        onPressed: (() {
                          email = emailController.text;
                          resetPassword(email);
                        }),
                        icon: const Icon(
                          Icons.read_more,
                          size: 28,
                        ),
                        label: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 35,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      TextButton.icon(
                        onPressed: (() {
                          Navigator.push(context, MaterialPageRoute(builder:
                              (context)=>const MyApp()),);
                        }),
                        icon: const Icon(
                          Icons.home,
                          size: 28,
                        ),
                        label: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 35,
                          child: const Text(
                            'Return Home',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

}