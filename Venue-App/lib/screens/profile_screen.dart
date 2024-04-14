import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/token_manager.dart';
//import 'package:venue/screens/edit_profile.dart';
import 'package:venue/screens/explore_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
    if (_selectedIndex == 0) { // Profile icon index
      // Navigate to the profile page
      NavigationUtils.navigateToPage(context, ExploreScreen());
    }
  });
}
 int _selectedIndex = 3;
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

      // Navigate to login screen based on userType
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      print('Error during logout: $error');
      // Handle error
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
          //NavigationUtils.navigateToPage(context, EditProfile());
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
                          child: Center(
                            child: Image.asset(
                              'assets/images/branch_details.png',
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
              
                  
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  
                Row(
                  children:[
                  Container(
                    // padding: EdgeInsets.only(left: paddingleft),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                      child:   Center(
                    child:  Icon(
        Icons.person,
        color: Colors.blue,
        size: 29,
      ),
                      ),
                  ),
                  SizedBox(width: 10,),
                  Text('Account',
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
                   SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                  children:[
                  Container(
                    // padding: EdgeInsets.only(left: paddingleft),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                      child:   Center(
                    child:  Icon(
        Icons.wallet,
        color: Colors.blue,
        size: 29,
      ),
                      ),
                  ),
                  SizedBox(width: 10,),
                  Text('Payment',
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
                   SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Row(
                  children:[
                  Container(
                    // padding: EdgeInsets.only(left: paddingleft),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                      child:   Center(
                    child:  Icon(
        Icons.contact_support,
        color: Colors.blue,
        size: 29,
      ),
                      ),
                  ),
                  SizedBox(width: 10,),
                  Text('Support',
                  style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                ),
                    SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ElevatedButton(
  onPressed: () {
    _logout(context); // Call the logout function when pressed
  },
  child: Row(
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
            Icons.logout,
            color: Colors.red,
            size: 29,
          ),
        ),
      ),
      SizedBox(width: 10,),
      Text(
        'Logout',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
      ),
    ],
  ),
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
        selectedItemColor: Colors.blue, // Color when selected
        unselectedItemColor: Colors.grey, // Color when not selected
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