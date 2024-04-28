import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue/components/custom_button.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:venue/config.dart';

class FormPage extends StatefulWidget {
  final int numberOfHalls;
  final int hallNumber;

  const FormPage({Key? key, required this.numberOfHalls, this.hallNumber = 1})
      : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  File? _image;
  final TextEditingController _hotelnameController = TextEditingController();
  final TextEditingController _abouthotelController = TextEditingController();
  final TextEditingController _restrictionsController = TextEditingController();
  //final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String ipAddress=Configip.ip;
  final picker = ImagePicker();
  //String? selectedCity;
  String? selectedCategory;
  String? selectedAvailablity;
  String? selectedVenuetype;
  // List<String> cityList = [
  //   'New York',
  //   'Los Angeles',
  //   'Chicago',
  //   'Houston',
  //   'Phoenix',
  //   'Philadelphia',
  //   'San Antonio',
  //   'San Diego',
  //   'Dallas',
  //   'San Jose',
  //   // Add more cities as needed
  // ];
  List<String> CategoryList = [
    'Birthday',
    'Music',
    'Wedding',
    'Corporate',
  ];

  List<String> AvailablityList = [
    'Yes',
    'No',
  ];
  List<String> VenuetypeList = [
    'veg',
    'nonveg',
  ];

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> sendHallDetailsToBackend() async {


    try {
      print('hall details called');
      bool isAvailable = selectedAvailablity == 'Yes';
      String hotelName=_hotelnameController.text;
      String aboutName=_abouthotelController.text;
      String restriction=_restrictionsController.text;
      String capacity=_capacityController.text;
      String price=_priceController.text;
      

      if (hotelName.isEmpty ||
        aboutName.isEmpty ||restriction.isEmpty || capacity.isEmpty ||
         price.isEmpty ) {
      // Handle empty fields error
      print('Please fill all fields');
      return;
    }
    final ioClient = IOClient(HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true);

    // Create a multipart request
    var multipartRequest = http.MultipartRequest(
        'POST', Uri.parse('http://$ipAddress:443/venue/hallDetails'));

      multipartRequest.fields['email'] = 'jebonlewis63@gmail.com';
      multipartRequest.fields['hallDetails'] = jsonEncode({
      'hotelName': hotelName,
      'aboutName': aboutName,
      'restriction':restriction,
      'capacity':capacity,
      'price': price,
      'availability':isAvailable,
      'service_category':selectedCategory,
      'venue_type':selectedVenuetype,
      });

       if (_image != null) {
      var imageFile = await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType('image', 'jpeg'),
      );
      multipartRequest.files.add(imageFile);
    } else {
      print('No image selected.');
    }

    // Send the multipart request using the custom IOClient
    var streamedResponse =
        await ioClient.send(multipartRequest).timeout(Duration(seconds: 60));

    // Process the response
    var response = await http.Response.fromStream(streamedResponse);


     if (response.statusCode == 201) {
      // Handle successful response
      print('halls details uploaded successfully');


      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('halls details uploaded successfully')),
      );
    } else {
      // Handle unsuccessful response
      print('Failed to upload branch details: ${response.reasonPhrase}');

      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload halls details: ${response.reasonPhrase}')),
      );
    }
  } catch (e) {
    // Handle errors
    print('Error uploading halls details: $e');

    // Display error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error uploading branch details: $e')),
    );
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Hall Details ${widget.hallNumber}',
          style: TextStyle(color: Colors.black),
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
                          child: _image != null
                              ? ClipOval(
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add_a_photo,
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
                            GestureDetector(
                              onTap: getImage,
                              child: Text(
                                'Upload Now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Hotel Name',
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
                    child: Center(
                      child: TextField(
                        controller: _hotelnameController,
                        decoration: InputDecoration(
                          hintText: "Enter Hotel Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
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
                    'About Hotel',
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
                      controller: _abouthotelController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Something About Your Hotel",
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
                    'Restrictions',
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
                      controller: _restrictionsController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Rules And Restrictions",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 15),
            // Container(
            //   alignment: Alignment.topLeft,
            //   padding: EdgeInsets.only(left: paddingleft),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Address',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 18,
            //         ),
            //       ),
            //       SizedBox(height: 6),
            //       Container(
            //         padding: EdgeInsets.only(left: paddingleft),
            //         width: MediaQuery.of(context).size.width * 0.9,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //             color: Colors.grey.withOpacity(0.4),
            //           ),
            //         ),
            //         child: Center(
            //           child: TextField(
            //             controller: _addressController,
            //             maxLines: null,
            //             keyboardType: TextInputType.multiline,
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //               hintText: "Address Here",
            //               hintStyle: TextStyle(color: Colors.grey),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capacity',
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
                    child: Center(
                      child: TextField(
                        controller: _capacityController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: "Enter Capacity",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
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
                    'Category',
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
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Category",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        value: selectedCategory,
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        items: CategoryList.map((String Categories) {
                          return DropdownMenuItem<String>(
                            value: Categories,
                            child: Text(Categories),
                          );
                        }).toList(),
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
                    'Availablity',
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
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Availablity",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        value: selectedAvailablity,
                        onChanged: (String? value) {
                          setState(() {
                            selectedAvailablity = value;
                          });
                        },
                        items:
                            AvailablityList.map((String selectedAvailablity) {
                          return DropdownMenuItem<String>(
                            value: selectedAvailablity,
                            child: Text(selectedAvailablity),
                          );
                        }).toList(),
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
                    'Venue Type',
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
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Venue Type",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        value: selectedVenuetype,
                        onChanged: (String? value) {
                          setState(() {
                            selectedVenuetype = value;
                          });
                        },
                        items: VenuetypeList.map((String selectedVenuetype) {
                          return DropdownMenuItem<String>(
                            value: selectedVenuetype,
                            child: Text(selectedVenuetype),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 15),
            // Container(
            //   alignment: Alignment.topLeft,
            //   padding: EdgeInsets.only(left: paddingleft),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'City',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 18,
            //         ),
            //       ),
            //       SizedBox(height: 6),
            //       Container(
            //         padding: EdgeInsets.only(left: paddingleft),
            //         width: MediaQuery.of(context).size.width * 0.9,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //             color: Colors.grey.withOpacity(0.4),
            //           ),
            //         ),
            //         child: Center(
            //           child: DropdownButtonFormField<String>(
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //               hintText: "Select City",
            //               hintStyle: TextStyle(color: Colors.grey),
            //             ),
            //             value: selectedCity,
            //             onChanged: (String? value) {
            //               setState(() {
            //                 selectedCity = value;
            //               });
            //             },
            //             items: cityList.map((String city) {
            //               return DropdownMenuItem<String>(
            //                 value: city,
            //                 child: Text(city),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 15),
            // Container(
            //   alignment: Alignment.topLeft,
            //   padding: EdgeInsets.only(left: paddingleft),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'State',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 18,
            //         ),
            //       ),
            //       SizedBox(height: 6),
            //       Container(
            //         padding: EdgeInsets.only(left: paddingleft),
            //         width: MediaQuery.of(context).size.width * 0.9,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //             color: Colors.grey.withOpacity(0.4),
            //           ),
            //         ),
            //         child: Center(
            //           child: DropdownButtonFormField<String>(
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //               hintText: "Select State",
            //               hintStyle: TextStyle(color: Colors.grey),
            //             ),
            //             value: selectedCity,
            //             onChanged: (String? value) {
            //               setState(() {
            //                 selectedCity = value;
            //               });
            //             },
            //             items: cityList.map((String city) {
            //               return DropdownMenuItem<String>(
            //                 value: city,
            //                 child: Text(city),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 15),
            // Container(
            //   alignment: Alignment.topLeft,
            //   padding: EdgeInsets.only(left: paddingleft),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Country',
            //         style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 18,
            //         ),
            //       ),
            //       SizedBox(height: 6),
            //       Container(
            //         padding: EdgeInsets.only(left: paddingleft),
            //         width: MediaQuery.of(context).size.width * 0.9,
            //         height: 60,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           border: Border.all(
            //             color: Colors.grey.withOpacity(0.4),
            //           ),
            //         ),
            //         child: Center(
            //           child: DropdownButtonFormField<String>(
            //             decoration: InputDecoration(
            //               border: InputBorder.none,
            //               hintText: "Select Country",
            //               hintStyle: TextStyle(color: Colors.grey),
            //             ),
            //             value: selectedCity,
            //             onChanged: (String? value) {
            //               setState(() {
            //                 selectedCity = value;
            //               });
            //             },
            //             items: cityList.map((String city) {
            //               return DropdownMenuItem<String>(
            //                 value: city,
            //                 child: Text(city),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: paddingleft),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Price',
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
                    child: Row(
                      children: [
                        Icon(
                          Icons.attach_money_rounded,
                          color: Colors.blue,
                          size: 29,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: "0.00",
                              hintStyle: TextStyle(color: Colors.grey),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Center(
                child: CustomButton(
                  onPressed: () {
                    sendHallDetailsToBackend();
                    if (widget.hallNumber < widget.numberOfHalls) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormPage(
                              numberOfHalls: widget.numberOfHalls,
                              hallNumber: widget.hallNumber + 1),
                        ),
                      );
                    } else {
                      // Handle completion, navigate to next screen, etc.
                    }
                  },
                  text: 'NEXT',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}