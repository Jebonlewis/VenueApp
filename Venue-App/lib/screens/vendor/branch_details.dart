import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart'; // Import path package
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/vendor/add_items.dart';
import 'package:venue/screens/choose_screen.dart';
import 'package:http/io_client.dart';

class BranchDetails extends StatefulWidget {
  const BranchDetails({Key? key}) : super(key: key);

  @override
  State<BranchDetails> createState() => _BranchDetailsState();
}

class _BranchDetailsState extends State<BranchDetails> {
  TextEditingController _searchController = TextEditingController();
  String ipAddress=Configip.ip;
  String _selectedPlace = '';
  String _selectedLocation = '';
  List<String> _suggestions = [];
  String _latitude = '';
  String _longitude = '';
  String selectedCity = '';
  String selectedCountry = '';
  String selectedState = '';
  bool _isSearching = false;
  String? selectedVendor;
  // String? selectedState;
  // String? selectedCountry;

  List<String> vendorList = [
    'Caterer',
    'Sounds',
    'Decorator',
    // Add more cities as needed
  ];

  
  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _saveLocation(String location, String latitude, String longitude) {
    print('Location saved: $location');
    print('Latitude saved: $latitude');
    print('Longitude saved: $longitude');
    print('Contry saved: $selectedCountry');
    print('State saved: $selectedState');

  }

  Future<void> _getSuggestions(String query) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
        setState(() {
          _suggestions.clear();
          for (var prediction in data['predictions']) {
            _suggestions.add(prediction['description']);
          }
        });
      }
    } catch (e) {
      print('Error getting suggestions: $e');
    }
  }

  void _searchAndSaveLocation() {
    if (!_isSearching) {
      setState(() {
        _isSearching = true;
      });
      _searchLocation(_searchController.text);
      _saveLocation(_selectedPlace, _latitude, _longitude);
    }
  }

  Future<void> _searchLocation(String query) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
        final placeId = data['predictions'][0]['place_id'];
        _getPlaceDetails(placeId);
      } else {
        setState(() {
          _selectedPlace = 'No results found';
        });
      }
    } catch (e) {
      print('Error searching location: $e');
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final apiKey = 'AIzaSyDMWSgHTmFD9UdPTYIvLkXww_eyRdI5ggA';
      final url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK' && data['result'] != null) {
        final formattedAddress = data['result']['formatted_address'];
        final addressComponents = data['result']['address_components'];

        String city = '';
        String state = '';
        String country = '';

        for (var component in addressComponents) {
          List types = component['types'];
          if (types.contains('locality')) {
            city = component['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          } else if (types.contains('country')) {
            country = component['long_name'];
          }
        }

        final latitude = data['result']['geometry']['location']['lat'];
        final longitude = data['result']['geometry']['location']['lng'];

        setState(() {
          _selectedPlace = formattedAddress;
          _selectedLocation = 'Latitude: $latitude, Longitude: $longitude';
          _latitude = latitude.toString();
          _longitude = longitude.toString();
          selectedCity = city;
          selectedState = state;
          selectedCountry = country;
        });
      } else {
        setState(() {
          _selectedPlace = 'No results found';
          _selectedLocation = '';
          _latitude = '';
          _longitude = '';
          selectedCity = '';
          selectedState = '';
          selectedCountry = '';
        });
      }}
 catch (e) {
      print('Error getting place details: $e');
    }
  }

  File? _image;
  final picker = ImagePicker();

  final TextEditingController _branchNameController = TextEditingController();
  final TextEditingController _aboutBranchController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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

  Future<void> _uploadBranchDetails(BuildContext context) async {
    try {
      // Get values from input fields
      String branchName = _branchNameController.text;
      String aboutBranch = _aboutBranchController.text;
      String address = _addressController.text;
      // String city = selectedVendor ?? '';
      // String state = selectedState ?? '';
      // String country = selectedCountry ?? '';

      // Validate if any required field is empty
      if (branchName.isEmpty ||
          aboutBranch.isEmpty ||
          address.isEmpty   
          ) {
        // Handle empty fields error
        print('Please fill all fields');
        return;
      }

      // Create an IOClient with a custom HttpClient that accepts all certificates
      final ioClient = IOClient(HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true);

      // Create a multipart request
      var multipartRequest = http.MultipartRequest(
          'POST', Uri.parse('http://$ipAddress:443/branch'));

      // Add JSON data to multipart request
      multipartRequest.fields['email'] = 'jebontarunlewis63@gmail.com';
      multipartRequest.fields['branchDetails'] = jsonEncode({
        'branchName': branchName,
        'aboutBranch': aboutBranch,
        'address': address,
        'city': selectedCity,
        'state': selectedState,
        'country': selectedCountry,
        'latitude':_latitude,
        'longitude':_longitude,
        'serviceCategory':selectedVendor
      });

      // Add image file to multipart request
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
        print('Branch details uploaded successfully');

        // Navigate to the Add Item page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddItems()), // Adjust with your AddItems page
        );

        // Display success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Branch details uploaded successfully')),
        );
      } else {
        // Handle unsuccessful response
        print('Failed to upload branch details: ${response.reasonPhrase}');

        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to upload branch details: ${response.reasonPhrase}')),
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
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vendor Type',
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
                                hintText: "Select Type Of Vendor",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              value: selectedVendor,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedVendor = value;
                                });
                              },
                              items: vendorList.map((String vendor) {
                                return DropdownMenuItem<String>(
                                  value: vendor,
                                  child: Text(vendor),
                                );
                              }).toList(),
                            ),
                          ),
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
                    child: Center(
                      child: TextField(
                        controller: _branchNameController,
                        decoration: InputDecoration(
                          hintText: "Enter Branch Name",
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
                      controller: _aboutBranchController,
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
                    child: Center(
                      child: TextField(
                        controller: _addressController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Address Here",
                          hintStyle: TextStyle(color: Colors.grey),
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
                    'Location',
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
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Location Here",
                          hintStyle: TextStyle(color: Colors.grey),
                          // suffixIcon: IconButton(
                          //   icon: Icon(Icons.search),
                          //   onPressed: () {
                          //     _searchLocation(_searchController.text);
                          //   },
                          // ),
                        ),
                        onChanged: (value) {
                          _getSuggestions(value);
                        },
                      ),
                    ),
                  ),
                  _suggestions.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            left: paddingleft,
                            top: 6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _suggestions
                                .map((suggestion) => GestureDetector(
                                      onTap: () {
                                        _searchController.text = suggestion;
                                        _searchLocation(suggestion);
                                      },
                                      child: Text(
                                        suggestion,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      : Container(),
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
                        _uploadBranchDetails(context);
                        _saveLocation(_selectedPlace, _latitude, _longitude);
                        // NavigationUtils.navigateToPage(context, AddItems());
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

