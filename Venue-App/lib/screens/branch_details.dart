import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/screens/add_items.dart';
import 'package:venue/screens/choose_screen.dart';

class BranchDetails extends StatefulWidget {
  const BranchDetails({Key? key}) : super(key: key);

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> {
  String? selectedCity;
  List<String> cityList = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    // Add more cities as needed
  ];

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
            NavigationUtils.navigateToPage(context, ChooseScreen());
          },
        ),
        title: Text(
          'Your Branch Details',
          style: TextStyle(fontSize: 19, color: Colors.black),
        ),
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
                    height: 170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload image',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Upload Now',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Branch Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Branch Name",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Branch',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.only(left: paddingleft),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Something About You",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
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
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Address Here",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'City',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
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
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select City",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: selectedCity,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      items: cityList.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'State',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
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
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select State",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: selectedCity,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      items: cityList.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Country',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 6),
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
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select Country",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: selectedCity,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      items: cityList.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Center(
                child: Column(
                  children: [
                    CustomButton(
                      onPressed: () {
                        NavigationUtils.navigateToPage(context, AddItems());
                      },
                      text: 'NEXT',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
