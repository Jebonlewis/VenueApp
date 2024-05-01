import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/profile_screen.dart';
import 'package:venue/components/token_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  String ipAddress = Configip.ip;

  late String _email;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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

  Future<void> _saveProfileDetails() async {
    try {
      print("called");
      String fullName = _fullNameController.text;
      String contact = _contactController.text;
      String gender = _genderController.text;
      print('fullName ${fullName}');
      final ioClient = IOClient(HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true);

      // Create a multipart request
      var multipartRequest = http.MultipartRequest(
          'POST', Uri.parse('http://$ipAddress:443/editProfile'));

      multipartRequest.fields['email'] = _email;
      multipartRequest.fields['ProfileDetails'] = jsonEncode({
        'fullName': fullName,
        'contact': contact,
        'gender': gender,
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
    } catch (e) {
      print('Error saving profile details: $e');
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
            NavigationUtils.navigateToPage(context, ProfileScreen());
          },
        ),
        title: Text(
          'Edit Profile',
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
                    'Full Name',
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
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Full Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'E-Mail',
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
                        readOnly: true,
                        controller: TextEditingController(text: _email),
                        decoration: InputDecoration(
                          hintText: "Enter E-mail ID",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'Contact',
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
                        controller: _contactController,
                        decoration: InputDecoration(
                          hintText: "Enter Phone Number",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    'Gender',
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
                      child: Row(
                        children: [
                          Checkbox(
                            value: _genderController.text == 'male',
                            onChanged: (value) {
                              setState(() {
                                _genderController.text = 'male';
                              });
                            },
                          ),
                          Text('Male'),
                          SizedBox(width: 10),
                          Checkbox(
                            value: _genderController.text == 'female',
                            onChanged: (value) {
                              setState(() {
                                _genderController.text = 'female';
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
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
                        _saveProfileDetails();
                        // NavigationUtils.navigateToPage(context, AddItems());
                      },
                      text: 'SAVE',
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
