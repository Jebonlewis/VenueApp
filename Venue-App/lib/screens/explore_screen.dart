import 'package:flutter/material.dart';
import 'package:venue/components/navigator.dart';
//import 'package:venue/screens/demo_screen.dart';
import 'package:venue/screens/profile_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isContainer3Clicked = false;
  bool isContainer2Clicked = false;
  bool isContainer4Clicked = false;
  bool isContainer1Clicked = false;

  Widget buildContainerListView() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        buildContainer(
          isContainer1Clicked,
          'Wedding',
          'assets/images/wedding.png',
          (bool newValue) {
            setState(() {
              isContainer1Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer2Clicked,
          'Birthday',
          'assets/images/birthday.png',
          (bool newValue) {
            setState(() {
              isContainer2Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer3Clicked,
          'Music',
          'assets/images/music.png',
          (bool newValue) {
            setState(() {
              isContainer3Clicked = newValue;
            });
          },
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
        buildContainer(
          isContainer4Clicked,
          'Corporate',
          'assets/images/wedding.png',
          (bool newValue) {
            setState(() {
              isContainer4Clicked = newValue;
            });
          },
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 3) {
        // Profile icon index
        // Navigate to the profile page
        NavigationUtils.navigateToPage(context, ProfileScreen());
      }
    });
  }

  Widget buildContainer(
    bool isClicked,
    String title,
    String imagePath,
    Function(bool) onTap,
  ) {
    return GestureDetector(
      onTap: () {
        onTap(!isClicked);
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: isClicked ? Color.fromRGBO(46, 138, 250, 1) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isClicked ? Colors.white : Colors.grey.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isClicked ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Location',
                style: TextStyle(
                  color: Color.fromRGBO(138, 189, 252, 1),
                  fontSize: 12,
                ),
              ),
              Text(
                'New York, USA',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(Icons.widgets_rounded), // Your left side icon
            onPressed: () {
              // Add your onPressed logic here
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications), // Another right side icon
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(55, 75, 248, 1),
                  Color.fromRGBO(46, 138, 250, 1),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned.fill(
            top: screenSize.height *
                0.5, // Adjust this value to change the gradient's end position
            child: Container(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                    left: paddingleft,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 19,
                          color: Color.fromRGBO(138, 189, 252, 1),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        'Discover Amazing Event Places',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(
                      left: paddingleft,
                      top: MediaQuery.of(context).size.height * 0.03),
                  child: Container(
                    padding: EdgeInsets.only(left: paddingleft),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(46, 138, 250, 1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 230, 228, 228)
                            .withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search here...",
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              // errorText: _emailValidationError,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Call the validation method when the text changes
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: paddingleft),
                      child: Text(
                        'Categories',
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: paddingleft),
                      child: GestureDetector(
                        onTap: () {
                          // NavigationUtils.navigateToPage(
                          //   context,
                          //   DemoScreen(),
                          // );
                        },
                        child: Text(
                          'View All',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(138, 189, 252, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: Container(
                    // color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: 130,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(right: 5, left: 5),

                        // color: Colors.black,
                        child: buildContainerListView(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: EdgeInsets.only(left: paddingleft),
                  child: Text(
                    'Popular Event Places',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.020,
                ),
                Container(
                  // color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            height: 230,
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 230, 228, 228),
                                  width: 1),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 230,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // color: Colors.red,
                                      ),
                                      child: Image.asset(
                                        'assets/images/lorem.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Lorem Ipsum',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color:
                                                Color.fromRGBO(55, 75, 248, 1),
                                          ),
                                          Text(
                                            '36 Guild Street London,UK',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 9),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_alt_rounded,
                                          size: 20,
                                          color: Color.fromRGBO(55, 75, 248, 1),
                                        ),
                                        Text(
                                          '36',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text('Book Now',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          Container(
                            height: 230,
                            width: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 230, 228, 228),
                                  width: 1),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 230,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        // color: Colors.red,
                                      ),
                                      child: Image.asset(
                                        'assets/images/lorem.png',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Lorem Ipsum',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color:
                                                Color.fromRGBO(55, 75, 248, 1),
                                          ),
                                          Text(
                                            '36 Guild Street London,UK',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 9),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.people_alt_rounded,
                                          size: 20,
                                          color: Color.fromRGBO(55, 75, 248, 1),
                                        ),
                                        Text(
                                          '36',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Spacer(),
                                        Text('Book Now',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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