import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/vendor/add_items.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:venue/components/token_manager.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AdditemDetails extends StatefulWidget {
  const AdditemDetails({Key? key}) : super(key: key);

  @override
  State<AdditemDetails> createState() => _AdditemDetailsState();
}

class _AdditemDetailsState extends State<AdditemDetails> {
  File? _image;
  late String _email;
  final picker = ImagePicker();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String ipAddress=Configip.ip;
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

   @override
  void initState() {
    super.initState();
    _fetchUserData();
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
  Future<void> sendItemDetailsToBackend() async {


    try {
      print('email, ${_email}');
      String itemName=_itemNameController.text;
      String aboutItem=_descriptionController.text;
      String price=_priceController.text;

      if (itemName.isEmpty ||
        aboutItem.isEmpty ||
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
        'POST', Uri.parse('http://$ipAddress:443/item'));

      multipartRequest.fields['email'] = _email;
      multipartRequest.fields['itemDetails'] = jsonEncode({
      'itemName': itemName,
      'aboutItem': aboutItem,
      'price': price,
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
      print('items details uploaded successfully');

      // Navigate to the Add Item page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddItems()), // Adjust with your AddItems page
      );

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('items details uploaded successfully')),
      );
    } else {
      // Handle unsuccessful response
      print('Failed to upload branch details: ${response.reasonPhrase}');

      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload branch details: ${response.reasonPhrase}')),
      );
    }
  } catch (e) {
    // Handle errors
    print('Error uploading branch details: $e');

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
            Icons.arrow_back, // Use the back arrow icon
            color: Colors.black,
          ),
          onPressed: () {
            NavigationUtils.navigateToPage(context, AddItems());
          },
        ),
        title: Text(
          'Add Items Details',
          style: TextStyle(fontSize: 19, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                left: paddingleft,
                top: MediaQuery.of(context).size.height * 0.03,
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
                              onTap:getImage,
                          child:  Text(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    'Item Name',
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
                      
                      controller: _itemNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Item Name",
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
                    'About Item',
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
                       controller: _descriptionController,
                      maxLines: null, // Allow multiple lines of text
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Something About Your Item",
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.01),
              child: Center(
                child: Column(
                  children: [
                    CustomButton(
                      onPressed: sendItemDetailsToBackend,
                      text: 'ADD ITEMS',
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
