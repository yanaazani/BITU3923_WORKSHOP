import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui/menu_page.dart';
import 'package:ui/model/patient_model.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
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
    final response = await http.get(Uri.parse('http://10.131.75.185:8080/'
        'pkums/patient/details/${widget.userId}'));
    if (response.statusCode == 200) {
      // Parse the JSON response into a `Patient` object.
      final patient = Patient.fromJson(jsonDecode(response.body));

      print(response.body);

      setState(() {
        _patient = patient;
        name = patient.name ?? '';
        email = patient.email ?? '';
        password = patient.password ?? '';
        ic = patient.ic ?? '';
        phone = patient.phone ?? '';
        height = patient.height ?? 0.0;
        weight = patient.weight ?? 0.0;
        gender = patient.gender ?? '';

        nameController.text = patient.name;
        emailController.text = patient.email;
        passwordController.text = patient.password;
        icController.text = patient.ic;
        phoneController.text = patient.phone;
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

  late Uint8List? _images = Uint8List(0);
  String imageUrl = "assets/profilepic.png";
  ImagePicker picker = ImagePicker();
  File? _image;

  /// Get from gallery
  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> updatePatient() async{
    uploadImage();
    /**
     * optionally update only the text field is not null
     */
    Map<String, dynamic> requestBody = {};

    if (nameController.text != null && nameController.text.isNotEmpty) {
      requestBody["name"] = nameController.text;
      name = nameController.text;
    }
    if (emailController.text != null && emailController.text.isNotEmpty) {
      requestBody["email"] = emailController.text;
      email = emailController.text;
    }
    if (icController.text != null && icController.text.isNotEmpty) {
      requestBody["ic"] = icController.text;
      ic = icController.text;
    }
    if (phoneController.text != null && phoneController.text.isNotEmpty) {
      requestBody["phone"] = phoneController.text;
      phone = phoneController.text;
    }
    if (weightController.text != null && weightController.text.isNotEmpty) {
      requestBody["weight"] = weightController.text;
      weight = double.tryParse(weightController.text) ?? 0.0; // Use 0.0 if parsing fails
    }
    if (heightController.text != null && heightController.text.isNotEmpty) {
      requestBody["height"] = heightController.text;
      height = double.tryParse(heightController.text) ?? 0.0; // Use 0.0 if parsing fails
    }

    if (genderController.text != null && genderController.text.isNotEmpty) {
      requestBody["gender"] = genderController.text;
      gender = genderController.text;
    }

    //"http://10.0.3.2:8080/patient/edit/${widget.userId}
    final response = await http.put(Uri.parse("http://10.131.75.185:8080/"
        "pkums/patient/edit/${widget.userId}"),
      headers:{
        "Content-type":"Application/json"
      },

      body: jsonEncode(requestBody),
    );
    print(response.body);

    if(response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Update successfully',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => MenuPage(userId: widget.userId)),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Update failed!',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );
    }
  }

  Future<void> fetchProfileImage() async {
    final response = await http.get(Uri.parse(
        'http://10.131.75.185:8080/pkums/image/getProfileImage/${(widget.userId)}')
    );

    if (response.statusCode == 200) {
      setState(() {
        _images = response.bodyBytes;
      });
    } else {
      // Handle errors, e.g., display a default image
      return null;
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) {
      return;
    }
    final uri = Uri.parse('http://10.131.75.185:8080/pkums/'
        'image/uploadSingleImage/${(widget.userId)}');
    final request = http.MultipartRequest('POST', uri);
    request.fields['userId'] = '${(widget.userId)}';
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        _image!.path,
      ),
    );

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Image is updated successfully',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Image failed to update successfully',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    fetchProfileImage();
  }
  void handleGenderChange(String value) {
    setState(() {
      genderController.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        backgroundColor: Colors.deepPurple[100],
        title: Container(child: const Text("Edit Profile Data"),),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: (){
            setState(() {
              showLogoutText = !showLogoutText;
            });
            // FocusScope.of(context).unfocus();
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
                        shape: BoxShape.circle,
                        image: _image == null
                            ? const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/profilepic.png")
                        )
                        : _image != null
                            ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!)
                        )
                            : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(_image!)
                        )
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
                        child: IconButton(onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text("Upload Image",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 25,
                              ),),
                              content: Text("Edit your image",style: GoogleFonts.poppins(
                                fontSize: 18,
                              ),),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    child: Text("Camera", style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    _getFromGallery();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    child: Text("Gallery", style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }, icon: const Icon(Icons.edit_outlined)),
                      ),
                    )
                  ],
                ),
              ),
              //Text field of profile data
              const SizedBox(height: 30),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Full Name", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: icController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Passport Number / Identity Card", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Phone Number", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Height (cm)", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Weight (kg)", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              const Text('Gender', style: TextStyle(
                  fontSize: 13,
              ),),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: genderController.text,
                    onChanged: (value) {
                      handleGenderChange(value as String);
                    },
                  ),
                  const Text('Male'),
                  Radio(
                    value: 'Female',
                    groupValue: genderController.text,
                    onChanged: (value) {
                      handleGenderChange(value as String);
                    },
                  ),
                  const Text('Female'),

                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Change Password", floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    )
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text(
                      "Cancel", style: TextStyle(
                      fontSize: 15, letterSpacing: 2, color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                  ElevatedButton(onPressed: (){
                    updatePatient();
                     }, child: const Text(
                      "Save", style: TextStyle(
                      fontSize: 15, letterSpacing: 2, color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),)
                    ),
                  )
                ],),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}