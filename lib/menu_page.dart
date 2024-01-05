import 'package:flutter/material.dart';
import 'package:ui/booking_appointment_page.dart';
import 'package:ui/feedback.dart';
import 'package:ui/schedule_appointment_page.dart';
import 'package:ui/user_profile.dart';

class MenuPage extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const MenuPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

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
                  child: Text('Hai ${widget.userId}'),
                ),
                ListTile(
                  title: Text('Privacy Policy'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
                ListTile(
                  title: Text('About Us'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
                ListTile(
                  title: Text('Logout'),
                  onTap: () {
                    // Handle item tap
                  },
                ),
                // Add more items as needed
              ],
            ),
          ),
          body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child:  MyGridView(userId: widget.userId),
              )
          )
      ),
    );

  }
}


class MyGridView extends StatefulWidget {
  final int userId; // Assuming userId is of type int
  const MyGridView({super.key, required this.userId});

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
         const Padding(padding: EdgeInsets.all(10),),
      SizedBox(
        height: 120,
        width: 500,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
          child: Container(
              color: Colors.deepPurple[100],
              child: GridView.count(
                primary: false,
                //padding: const EdgeInsets.all(10),
                crossAxisSpacing: 2,
                mainAxisSpacing: 5,
                crossAxisCount: 4,
                children: <Widget>[
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Appointment", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(icon: const Icon(Icons.local_hospital), iconSize: 50,
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingPage(userId: widget.userId)),);
                        },),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Schedule", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ScheduleAppointmentPage(userId: widget.userId,)),);
                          },
                          icon: const Icon(Icons.calendar_month)),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Feedback", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 50,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedbackPage(userId: widget.userId,)),);
                          },
                          icon: const Icon(Icons.feedback_rounded)),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text("Profile", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
                      IconButton.filledTonal(
                          iconSize: 50 ,
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
          child: const SingleChildScrollView(
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
      ],
    );
  }
}

class PictureWidget extends StatelessWidget {
  final String imagePath;

  const PictureWidget({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          imagePath,
          width: 400, // Set the width as needed
          height: 500, // Set the height as needed
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
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      padding: const EdgeInsets.all(25),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(15.0), // Set the border radius
      ),
      child: ListView(
        children: [
          buildListBar(context, 'Announcement 1', 'Salam sejahtera!'
              ' \n\nDear Respected customer,\n'
              'Please attend the clinic right at the time of your appointment. '
              '\n\nPatient who do not '
              'meet the appointment time will not be accepted and will need to book a new slot.\n'
              '\nFor any question, please call 06-2701221'),
          buildListBar(context, 'Announcement 2', 'Make sure to make appointment!'),
        ],
      ),
    );
  }

  Widget buildListBar(BuildContext context, String announcement, String announcementText) {
    return GestureDetector(
      onTap: () {
        showAnnouncementBottomSheet(context, announcementText);
      },
      child: Container(
        height: 25,
        margin: const EdgeInsets.only(bottom: 8),
        color: Colors.deepPurple[100], // Customize the color of the list bar
        child: Center(
          child: Text(
            announcement,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 16),
                Text(
                  announcementText,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            )
        );
      },
    );
  }
}

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
