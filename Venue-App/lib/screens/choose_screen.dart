import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/vendor/branch_details.dart';
import 'package:venue/screens/user/login_screen.dart';
import 'package:venue/screens/user/register_screen.dart';
import 'package:venue/screens/vendor/vendor_login.dart';
import 'package:venue/screens/vendor/vendor_register.dart';
import 'package:venue/screens/venue/venue_login.dart';
import 'package:venue/screens/venue/venue_register.dart';
class ChooseScreen extends StatefulWidget {
  const ChooseScreen({Key? key}) : super(key: key);

  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  bool showBecomeVendorButtons = false;
  bool showFindServiceButtons = false;
  bool showVendorButtons = false;

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    Size screenSize = MediaQuery.of(context).size;
    double paddingVertical = screenSize.height * 0.09;
    double paddingleft = screenSize.width * 0.05;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/bg.png'), // Change this to your image path
                fit: BoxFit.cover,
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
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.5)],
                begin: Alignment.centerLeft,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding:
                    EdgeInsets.only(top: paddingVertical, left: paddingleft),
                child: Material(
                  elevation: 20,
                  shadowColor: Color.fromRGBO(46, 138, 250, 1),
                  shape: CircleBorder(),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(55, 75, 248, 1),
                          Color.fromRGBO(46, 138, 250, 1)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/Vector.png',
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: paddingleft),
                child: Text(
                  'What You Want\nTo Be Here...',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(left: paddingleft),
                child: Text(
                  'Explore The Wide Range Of Venues and Vendors.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showBecomeVendorButtons = !showBecomeVendorButtons;
                          showFindServiceButtons = false;
                          showVendorButtons=false;
                        });
                      },
                      child: Container(
                        height: 160,
                        width: 155,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                               color: showBecomeVendorButtons ? Colors.blue : Colors.grey.withOpacity(0.4),
                              width: 2.0,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/becomeavendor.png',
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text('Become a Vendor',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showFindServiceButtons = !showFindServiceButtons;
                          showBecomeVendorButtons = false;
                            showVendorButtons = false; 
                        });
                      },
                      child: Container(
                        height: 160,
                        width: 155,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: showFindServiceButtons ? Colors.blue : Colors.grey.withOpacity(0.4),
                              width: 2.0,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/findaservice.png',
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text('Find a Service',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
              ),
              SizedBox(height:MediaQuery.of(context).size.height * 0.02),
               GestureDetector(
                      onTap: () {
                        setState(() {
                          showVendorButtons = !showVendorButtons;
                          showBecomeVendorButtons = false;
                           showFindServiceButtons = false; 
                          
                        });
                      },
                      child: Container(
                        height: 160,
                        width: 155,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: showVendorButtons ? Colors.blue : Colors.grey.withOpacity(0.4),
                              width: 2.0,
                            )),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/findaservice.png',
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            Text('Become a Venue',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Visibility(
                visible: showBecomeVendorButtons,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonSmall(
                      onPressed: () {
                         NavigationUtils.navigateToPage(
                              context,
                             VendorLoginScreen(),
                            );
                      },
                      text: 'SIGN IN',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomButtonSmall(
                      onPressed: () {
                        NavigationUtils.navigateToPage(
                              context,
                             SignupVendor(),
                            );
                      },
                      text: 'SIGN UP',
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: showFindServiceButtons,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonSmall(
                      onPressed: () {
                        NavigationUtils.navigateToPage(
                              context,
                            LoginScreen(),
                            );
                      },
                      text: ' SIGN IN',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomButtonSmall(
                      onPressed: () {
                        NavigationUtils.navigateToPage(
                              context,
                              SignUp(),
                            );
                
                      },
                      text: 'SIGN UP',
                    ),
                  ],
                ),
              ),
               Visibility(
                visible: showVendorButtons,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButtonSmall(
                      onPressed: () {
                        NavigationUtils.navigateToPage(
                              context,
                            VenueLoginScreen(),
                            );
                      },
                      text: ' SIGN IN',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomButtonSmall(
                      onPressed: () {
                        NavigationUtils.navigateToPage(
                              context,
                              SignupVenue(),
                            );
                
                      },
                      text: 'SIGN UP',
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}