import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/booking_appointment_page.dart';
import 'package:ui/main.dart';
import 'package:ui/review_doctor.dart';
import 'package:ui/schedule_appointment_page.dart';
import 'package:ui/user_profile.dart';
import 'package:http/http.dart' as http;
import 'model/doctor_model.dart';

class MenuPage extends StatefulWidget {
  final int userId;
  const MenuPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState(userId: userId);
}

class _MenuPageState extends State<MenuPage> {
  late final int userId;
  _MenuPageState({required this.userId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.purple[50],
          appBar: AppBar(backgroundColor: Colors.purple[50],
            title:
            const Text("MediConnect", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
            ),
            ),
            automaticallyImplyLeading: false,
            actions: [
              Padding(padding: const EdgeInsets.only(right: 20.0),
                child: Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: (){
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Icon(Icons.menu_outlined, size: 26.0,),
                    );
                  }
                )
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[50],
                  ),
                  child: Text(''),
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('About Us'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AboutMe(),
                    ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
                // Add more items as needed
              ],
            ),
          ),
          body: SingleChildScrollView(
              child: SizedBox(
                height: 1250, //MediaQuery.of(context).size.height,
                child:  MyGridView(userId: widget.userId),
              )
          )
      ),
    );
  }
}

class MyGridView extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const MyGridView({Key? key, required this.userId}) : super(key: key);


  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  get onPressed => null;
  late Future<List<Doctor>> doctors;

  Future<List<Doctor>> getDoctors() async {
    final response = await http.get(Uri.parse('http://10.131.75.185:8080'
        '/pkums/doctor/list'));
    if (response.statusCode == 200) {
      // Parse the JSON response into a list of `Doctor` objects.
      final List<dynamic> doctorList = jsonDecode(response.body);
      final List<Doctor> doctors = doctorList.map((json) => Doctor.fromJson(json)).toList();

      return doctors;
    } else {
      throw Exception('Failed to fetch doctors');
    }
  }

  @override
  void initState() {
    super.initState();
    doctors = getDoctors();
  }

  Widget buildDoctorsList(List<Doctor>? doctors) {
    return doctors != null && doctors.isNotEmpty
        ? ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index){
          //doctors.map((doctor)
            return DoctorCard(
              icDoctor: doctors[index].icDoctor ?? 0,
            firstName: doctors[index].firstName ?? '',
            lastName: doctors[index].lastName ?? '',
            email: doctors[index].email ?? '',
            rating: doctors[index].rating ?? 0,
            review: doctors[index].review ?? '',
              userId: widget.userId,
          );
        },
      )
        : Text('No doctors available');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ListBarWidget(),
        const Padding(padding: EdgeInsets.only(top: 20, left: 10),
          child: Row(
            children: [
              Text('Categories',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30),),
            ],
          ),),
         const Padding(padding: EdgeInsets.all(3),),
      SizedBox(
        height: 110,
        width: 500,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
          child: Container(
              margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(15.0), // Set the border radius
            ),
              child: GridView.count(
                primary: false,
                //padding: const EdgeInsets.all(10),
                crossAxisSpacing: 2,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                children: <Widget>[
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Appointment", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(icon: const Icon(Icons.local_hospital), iconSize: 45,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingPage(userId: widget.userId)),);
                        },),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Schedule", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 45,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ScheduleAppointmentPage(userId: widget.userId,)),);

                          },
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ),
                  /**Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Feedback", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 40,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackPage(userId: widget.userId,)),);
                          },
                          icon: const Icon(Icons.feedback_rounded)),
                    ],
                  ),**/
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Profile", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 45 ,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile(userId: widget.userId)),);
                          },
                          icon: const Icon(Icons.people)),
                    ],
                  ),
                ],
              ),
            ),
      ),
            ),
        const Padding(padding: EdgeInsets.all(10),),
        const Row(
          children: [
            Expanded(
              child: Text(
                'Our Doctors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 400, // Adjust the height as needed
          child: FutureBuilder<List<Doctor>>(
            future: doctors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      icDoctor: snapshot.data![index].icDoctor,
                      firstName: snapshot.data![index].firstName,
                      lastName: snapshot.data![index].lastName,
                      email: snapshot.data![index].email,
                      rating: snapshot.data![index].rating,
                      review: snapshot.data![index].review,
                      userId: widget.userId,
                    );
                  },
                );
              }
            },
          ),
        ),
        Padding(padding: EdgeInsets.all(10),),
        Row(
          children: [
            Expanded(
              child: Text(
                'Highlights',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_sharp, // Replace with the desired icon
              size: 30,
              color: Colors.black54, // Replace with the desired color
            ),
          ],
        ),
         Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.deepPurple[50],
            borderRadius: BorderRadius.circular(15.0), // Set the border radius
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                PictureWidget(imagePath: "assets/asaprokok.jpg"),
                PictureWidget(imagePath: "assets/segeralakukancovidtest.jpg"),
                PictureWidget(imagePath: "assets/pelitupmuka.jpg"),
                PictureWidget(imagePath: "assets/pencegahanmusimbanjir.jpg"),
                PictureWidget(imagePath: "assets/eatwell.jpg"),
                PictureWidget(imagePath: "assets/musimpanas.jpg"),

              ]
            ),

    ),
          ),
      ]
    );

  }
}
Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform logout logic here
              // For now, just navigate to the login screen
              Navigator.of(context).pop(); // Close the dialog
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const MyApp(),
              ),
              );// Replace with your login route
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

class PictureWidget extends StatelessWidget {
  final String imagePath;

  const PictureWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.asset(
          imagePath,
          width: 350, // Set the width as needed
          height: 350, // Set the height as needed
          fit: BoxFit.cover, // Adjust the BoxFit property as needed
        ),
      ),
    );
  }
}

/**
 * This for important announcement container inside menu interface
 */
class ListBarWidget extends StatelessWidget {
  const ListBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      padding: const EdgeInsets.all(25),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(15.0), // Set the border radius
      ),
      child: Center(
        child: ListView(
          children: [
            buildListBar(context, '\t\t\t\t\t\t\t\t\t'
                '\t\t\t\t\t\t\t\t\t\t\t\t\tAnnouncement 1', 'Salam sejahtera!'
                ' \n\nDear Respected customer,\n'
                'Please attend the clinic right at the time of your appointment. '
                '\n\nPatient who do not '
                'meet the appointment time will not be accepted and will need to book a new slot.\n'
                '\nFor any question, please call 06-2701221'),
            buildListBar(context, '\t\t\t\t\t\t\t\t\t\t\t\t\t\t'
                '\t\t\t\t\t\t\t\tAnnouncement 2', 'Make sure to make appointment!'),
          ],
        ),
      ),
    );
  }

  Widget buildListBar(BuildContext context, String announcement, String announcementText) {
    return GestureDetector(
      onTap: () {
        print('Review button tapped!');
       showAnnouncementBottomSheet(context, announcementText);
      },
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
        child: Container(
          height: 30,
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.deepPurple[100], // Customize the color of the list bar
          child: Center(
            child: Text(
              announcement,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  void showAnnouncementBottomSheet(BuildContext context, String announcementText) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.info, // Replace with the icon you want to use
                  size: 50,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 20),
                Text(
                  announcementText,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            )
        );
      },
    );
  }
}

/**
 * This for important infographic photos display under Highlights
 * inside menu interface
 */
class Infografik extends StatelessWidget {
  const Infografik({required this.image});
final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 400,
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
    image: DecorationImage(
    image: AssetImage(image)),
      ),
    );
  }

}

/**
 * This class is for Privacy Policy inside menu button choices.
 */
class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for MediConnect',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last updated: 17/1/2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to MediConnect! This Privacy Policy outlines how your '
                  'personal information is collected, used, and shared when '
                  'you use our services.',
            ),
            SizedBox(height: 16.0),
            Text(
              'How We Use Your Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'We use the collected information for various '
                  'purposes, including but not limited to:',
            ),
            PrivacyPolicyList(),
            SizedBox(height: 16.0),
            Text(
              'Sharing Your Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'We may share your personal information with:',
            ),
            PrivacyPolicyList2(),
            SizedBox(height: 16.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'If you have any questions or concerns about this Privacy Policy, '
                  'please contact us at 06-123456',
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * This is to display the privacy policy content
 */
class PrivacyPolicyList extends StatelessWidget {
  const PrivacyPolicyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        bulletedPoint('Providing and maintaining our services'),
        bulletedPoint('Personalizing your experience'),
        bulletedPoint('Improving our services'),
        bulletedPoint('Communicating with you'),
        bulletedPoint('Ensuring the security of our platform'),
      ],
    );
  }

  Widget bulletedPoint(String text) {
    return ListTile(
      leading: const Icon(Icons.check, size: 16),
      title: Text(text, style: const TextStyle(fontSize: 14),),
    );
  }
}
/**
 * This is to display the About Me content
 */
class PrivacyPolicyList2 extends StatelessWidget {
  const PrivacyPolicyList2({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        bulletedPoint2('Healthcare providers for the purpose of '
            'facilitating medical services'),
        bulletedPoint2('Legal authorities when required by law'),
      ],
    );
  }
  Widget bulletedPoint2(String text) {
    return ListTile(
      leading: const Icon(Icons.check, size: 16),
      title: Text(text, style: const TextStyle(fontSize: 14),),
    );
  }
}

/**
 * This class is for About Me inside menu button choices.
 */
class AboutMe extends StatelessWidget {
  const AboutMe({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('About Us'),
        ),
        body: const SingleChildScrollView(
                padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MediConnect: Patient Appointments and Medical Records System',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'MediConnect, a groundbreaking initiative developed by Workshop 2 '
                  'students at UTeM, aims to redefine healthcare convenience '
                  'within the university community. This cutting-edge hybrid '
                  'platform seamlessly integrates mobile accessibility for '
                  'lecturers and students, complemented by a user-friendly web '
                  'interface tailored for healthcare providers.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Innovation for Streamlined Healthcare Services',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'MediConnect addresses the challenges faced by both patients'
                  ' and doctors at UTeM\'s Pusat Kesihatan UTeM (PKU). Through '
                  'the innovative system, we simplify the entire process of '
                  'appointment scheduling, providing an effortless gateway to '
                  'top-notch healthcare services within the university.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Key Objectives',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Our primary objectives revolve around creating a user-friendly'
                  ' mobile app dedicated to UTeM, enhancing the booking, tracking,'
                  ' and check-in experience. Simultaneously, we\'ve designed a '
                  'robust web platform for doctors, empowering them with efficient '
                  'management tools for appointments, room allocations, and medical notes.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Benefits for Doctors and Patients',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'One of the distinctive features of MediConnect is the'
                  ' implementation of automatic updates of medical notes '
                  'in the mobile app post-appointments. This ensures that '
                  'both doctors and patients have access to real-time information,'
                  ' fostering a collaborative and informed healthcare environment.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Student Project for Healthcare Transformation',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'It\'s essential to note that MediConnect is a product of '
                  'dedication and innovation by Workshop 2 students. This '
                  'project is a testament to our commitment to advancing '
                  'healthcare technologies within the academic community.'
                  ' We believe that the MediConnect system will not only'
                  ' simplify healthcare processes but also contribute '
                  'to the overall well-being of UTeM\'s academic community.',
            ),
            SizedBox(height: 16.0),
          ],
        ),
      )
    );
  }
}
class DoctorCard extends StatefulWidget {
  final int icDoctor;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? rating;
  final String? review;
  final int userId;

  DoctorCard({
    required this.icDoctor,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.rating,
    required this.review,
    required this.userId,
  }) : super(key: ValueKey(userId));


  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  Map<int, String> doctorImages = {
    1: "shiny2.jpg",
    1234567: "shiny.jpg",
    9876543: "chaeunwoo.jpg",
    // Add more mappings as needed
  };

  @override
  Widget build(BuildContext context) {
    print('Doctor IC: ${widget.icDoctor}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 200,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Image.asset("assets/${doctorImages[widget.icDoctor]}",
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.firstName ?? ''} ${widget.lastName ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Dental',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Rate: '),
                          Icon(Icons.star, color: Colors.yellow, size: 20),
                          Spacer(flex: 1),
                          Text('${widget.rating ?? 0}'),
                          Spacer(flex: 1),
                         /** GestureDetector(
                            onTap: () {
                              print('Review button tapped!');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewPage(
                                    icDoctor: widget.icDoctor,
                                    userId: widget.userId,
                                    doctorFirstName: widget.firstName,
                                    doctorLastName: widget.lastName,
                                    doctorEmail: widget.email,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Reviews',
                              style: TextStyle(
                                color: Colors.blue,
                                // You can customize the color as needed
                              ),
                            ),
                ),**/
                          Spacer(flex: 1),
                          Spacer(flex: 7),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}