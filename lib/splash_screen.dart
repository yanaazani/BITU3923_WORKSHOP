import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:ui/main.dart';

void main() {
  runApp(MaterialApp(
    home: IntroScreen(),
  ));
}

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});

  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Welcome to MediConnect',
      body: 'Patient Appointments and Medical '
          'Records System, revolutionizing healthcare convenience at UTeM!',
      image: Center(
        child: Image.asset("assets/test3.jpg", fit: BoxFit.cover),
      ),decoration: PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold
      ),
      bodyTextStyle: TextStyle(
        fontSize: 15.0, // Set the font size for the body text
      ),
    )
    ),
    PageViewModel(
        title: 'Ready for the next step?',
        body: ' Sign in or create an account '
  'to explore personalized healthcare. \nYour appointments and medical '
  'records are just a click away.'
  ' \n\nLets begin your journey to a healthier future!',
        image: Center(
          child: Image.asset("assets/test2.jpg", fit: BoxFit.cover),
        ),decoration: PageDecoration(
        titleTextStyle: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold
        ),
      bodyTextStyle: TextStyle(
        fontSize: 15.0, // Set the font size for the body text
      ),
    )
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: IntroductionScreen(
        pages: pages,
        dotsDecorator: DotsDecorator(
          size: Size(10,10),
          color: Colors.deepPurple,
          activeColor: Colors.deepPurple[200],
        ),
        showDoneButton: true,
        done: Text('Done', style: TextStyle(fontSize: 20,),),
        showSkipButton: true,
        skip: Text('Skip', style: TextStyle(fontSize: 20),),
        showNextButton: true,
        next: Icon(Icons.arrow_forward, size: 20,),
        onDone: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder:
              (context)=> const MyApp()));
        },
      ),backgroundColor: Colors.white,
    );
  }


}

