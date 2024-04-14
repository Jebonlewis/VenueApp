import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/search_screen.dart';

class WelcomeScreen extends   StatefulWidget {
  const  WelcomeScreen({super.key});

  @override
  State< WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State< WelcomeScreen> {
  @override
  Widget build(BuildContext context) {   
     Size screenSize = MediaQuery.of(context).size;
    double paddingVertical = screenSize.height * 0.2;
    double paddingleft = screenSize.width * 0.05;
  
    return Scaffold(
 body: Stack(
  children: [
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:AssetImage('assets/images/map.png'),
          fit: BoxFit.cover ),
      ),
    ),
     Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
           Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),  
     Container(
  child: Padding(
    padding: EdgeInsets.only(left: paddingleft, bottom: paddingVertical),
    child: Column(
      
      mainAxisAlignment: MainAxisAlignment.end, // Changed to MainAxisAlignment.start
      crossAxisAlignment: CrossAxisAlignment.start, // Added CrossAxisAlignment.start
      children: [
        Text(
          'Search, Discover\nand Celebrate\nyour Event',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        Text(
          'Find what you will to do. Find cool event\nplace for celebrate your joy.',
          style: TextStyle(fontSize: 16),
        ),
       
      ],
    ),
  ),

   
   
),
 Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      padding: EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.04),
        child: CustomButton(
          onPressed: () {
              NavigationUtils.navigateToPage(context, SearchScreen());
          },
          text: 'NEXT',
        ),
      
    ),
  ),
  ],
 ),
    );
  }
}