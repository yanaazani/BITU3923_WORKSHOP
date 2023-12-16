import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(userId: userId);
}

class _ProfilePageState extends State<ProfilePage> {
  late final int userId;
  _ProfilePageState({required this.userId});

  bool isObsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[100],
          title: Container(child: const Text("Profile Page"),),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                }, child:
              const Icon(Icons.more_horiz_outlined),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },

            //For profile picture
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130, height: 130, decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1)
                          ),
                        ],
                        shape: BoxShape.circle, image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/profilepic.png"),
                      ),

                      ),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          height: 40, width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, border: Border.all(
                              width: 3,
                              color: Colors.white
                          ),
                            color: Colors.deepPurple[100],
                          ),
                          child: const Icon(Icons.edit_outlined),
                        ),
                      )
                    ],
                  ),
                ),

                //Text field of profile data
                const SizedBox(height: 30),
                buildTextField("Full Name", "Shaufy Yana binti mohd Eazni", false),
                buildTextField("IC", "011210-02-0426", false),
                buildTextField("Phone Number", "0116499659", false),
                buildTextField("Gender", "F", false),
                buildTextField("Height", "154cm", false),
                buildTextField("Weight", "52kg", false),
                buildTextField("Email", "B032110265@student.utem.edu.my", false),
                buildTextField("Password", "*******", true),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(onPressed: (){}, child: const Text(
                        "Cancel", style: TextStyle(
                        fontSize: 15, letterSpacing: 2, color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                    ElevatedButton(onPressed: (){}, child: const Text(
                        "Save", style: TextStyle(
                        fontSize: 15, letterSpacing: 2, color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)
                      ),
                    )
                  ],)
              ],
            ),
          ),
        )
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isPasswordTextField){
    return Padding(padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObsecurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField ?
            IconButton(icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
                onPressed: (){} ): null,
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText, floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            )
        ),
      ),
    );
  }

}
