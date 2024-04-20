import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/user/login_screen.dart';
import 'package:venue/screens/welcome_screen.dart';

class OverlayFilter extends StatefulWidget {
  const OverlayFilter({super.key});

  @override
  State<OverlayFilter> createState() => _OverlayFilterState();
}

class _OverlayFilterState extends State<OverlayFilter> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.16,
                        left: paddingleft),
                    child: const Text(
                      "Filter",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Container(
                 
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: paddingleft),
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: 60,
                              decoration: BoxDecoration(
                              
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Location",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.height * 0.036),
                                  
                                      
                           Container(
                              decoration: BoxDecoration(
                               
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.4),
                                  )),
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Icon(
                                  Icons.location_searching,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                                   
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event type',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Container(
                          padding: EdgeInsets.only(left: paddingleft),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Event type",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dates',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Container(
                          padding: EdgeInsets.only(left: paddingleft),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Select dates",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Capacity',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Container(
                          padding: EdgeInsets.only(left: paddingleft),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Enter numbers of guest",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //     left: MediaQuery.of(context).size.width * 0.01,
                  //     right: MediaQuery.of(context).size.width * 0.04,
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {},
                          text: 'SEARCH',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.10,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  NavigationUtils.navigateToPage(
                    context,
                   WelcomeScreen(),
                  );
                },
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.06,
              child: Image.asset(
                'assets/images/Vectorbg1.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
