import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/token_manager.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/choose_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/explore_screen.dart';
import 'package:venue/screens/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:venue/components/token_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;
  late String _email;
  String ipAddress = Configip.ip;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        NavigationUtils.navigateToPage(context, ExploreScreen());
      }
      else if (_selectedIndex == 2) {
        // NavigationUtils.navigateToPage(context, OrderScreen());
      }
      else if (_selectedIndex == 1) {
        NavigationUtils.navigateToPage(context, OverlayFilter());
      }
    });
  }
  

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _logout(BuildContext context) async {
    try {
      String? token = await TokenManager().getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      String? userType = decodedToken['userType'];
      String? fullName = decodedToken['fullname'];
     
      
      await TokenManager().deleteToken();

      String message =
          fullName != null ? '$userType $fullName logged out' : 'Logged out';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  Future<void> _fetchUserData() async {
    String? token = await TokenManager().getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _email = decodedToken['email'];
      });
    } else {
      print('No token found');
    }
  }
  
  Future<String?> _fetchProfileImage() async {
  try {
    // Make a GET request to your backend API endpoint
    print('called');
    final response = await http.get(Uri.parse('http://$ipAddress:443/displayProfile?email=$_email'));

    if (response.statusCode == 200) {
      // Decode the response body from base64
      Map<String, dynamic> imageData = jsonDecode(response.body);
      return imageData['image'];
    } else {
      // Handle error response
      print('Failed to load profile image: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    // Handle network or other errors
    print('Error loading profile image: $error');
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            NavigationUtils.navigateToPage(context, ExploreScreen());
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 19, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
                NavigationUtils.navigateToPage(context, EditProfile());
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                left: paddingleft,
                top: MediaQuery.of(context).size.height * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
  height: 150,
  width: 150,
  decoration: BoxDecoration(
    color: Colors.grey.withOpacity(0.1),
    shape: BoxShape.circle,
  ),
  child: FutureBuilder<String?>(
    future: _fetchProfileImage(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Show a loading indicator while fetching the image
      } else if (snapshot.hasError) {
        return Icon(
          Icons.error,
          color: Colors.red,
          size: 40,
        ); // Show an error icon if loading fails
      } else if (snapshot.hasData) {
        // Show the image if loading is successful
        return CircleAvatar(
          backgroundImage: MemoryImage(
            base64Decode(snapshot.data!),
          ),
          radius: 75,
        );
      } else {
        return Icon(
          Icons.account_circle,
          color: Colors.blue,
          size: 100,
        ); // Show a default icon if there's no data
      }
    },
  ),
),
                  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  
                  Row(
                    children:[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.blue,
                            size: 29,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('Account',
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  
                  Row(
                    children:[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.wallet,
                            color: Colors.blue,
                            size: 29,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('Payment',
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  
                  Row(
                    children:[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.contact_support,
                            color: Colors.blue,
                            size: 29,
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('Support',
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  
                  Row(
                    children:[
                      GestureDetector(
                        onTap: () {
                          _logout(context);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 29,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text('Logout',
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                      )
                    ],
                  ),

                ],
              ),
            ),
           
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

