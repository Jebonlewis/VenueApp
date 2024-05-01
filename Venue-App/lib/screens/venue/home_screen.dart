import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/snack_bar.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/profile_screen.dart';
import 'package:venue/screens/venue/form_screen.dart';
import 'dart:convert'; // Import this for JSON encoding
import 'package:http/http.dart' as http; // Import the http package
import 'dart:io';
class HomeVenue extends StatefulWidget {
  const HomeVenue({Key? key});

  @override
  State<HomeVenue> createState() => _HomeVenueState();
}

class _HomeVenueState extends State<HomeVenue> {
  TextEditingController _searchController = TextEditingController();
  String ipAddress=Configip.ip;
  String _selectedPlace = '';
  String _selectedLocation = '';
  List<String> _suggestions = [];
  String _latitude = '';
  String _longitude = '';
    bool _isSearching = false;
  final TextEditingController _venuenameController = TextEditingController();
  final TextEditingController _venueaddressController = TextEditingController();
  final TextEditingController _numberofhallsController =
      TextEditingController();
 final TextEditingController _venuelocationController = TextEditingController();
  int numberOfHalls = 0;
  String? selectedCity;
  String? _venuenameValidationError;
  String? _venueaddressValidationError;
  String? _venuelocationValidationError;
  String? _venuenumberofhallsValidationError;
  List<String> cityList = [
    'Udupi',
    'Manipal',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Chennai',
    'Kolkata',
    'Surat',
    'Pune',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara'
  ];
  String? selectedState;
  List<String> stateList = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
    // Add more cities as needed
  ];
  String? selectedCountry;
  List<String> countryList = [
    'India',
    'United States',
    'China',
    'Japan',
    'Germany',
    'United Kingdom',
    'France',
    'Brazil',
    'Italy',
    'Canada',
    'South Korea',
    'Russia',
    'Australia',
    'Spain',
    'Mexico',
    'Indonesia',
    'Netherlands',
    'Saudi Arabia',
    'Turkey',
    'Switzerland'
  ];

 @override
   void dispose() {
    _searchController.dispose();
    _venuenameController.dispose();
    _venueaddressController.dispose();
    _venuelocationController.dispose();
    _numberofhallsController.dispose();
    super.dispose();
  }

void _saveLocation(String location, String latitude, String longitude) {
    print('Location saved: $location');
    print('Latitude saved: $latitude');
    print('Longitude saved: $longitude');
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
void _onSuggestionTapped(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _searchLocation(suggestion);
      _suggestions.clear(); // Clear suggestions after tapping on one
    });
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
        final latitude = data['result']['geometry']['location']['lat'];
        final longitude = data['result']['geometry']['location']['lng'];

        setState(() {
          _selectedPlace = formattedAddress;
          _selectedLocation = 'Latitude: $latitude, Longitude: $longitude';
          _latitude = latitude.toString();
          _longitude = longitude.toString();
        });
      } else {
        setState(() {
          _selectedPlace = 'No results found';
          _selectedLocation = '';
          _latitude = '';
          _longitude = '';
        });
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
  }



  Future<void> _sendVenueDetails() async {
    try {
      print("venue Details called");
        var venueDetails= {
          'email':'jebonlewis63@gmail.com',
          'VenueName': _venuenameController.text,
          'address': _venueaddressController.text,
          'city': selectedCity ?? '',
          'state': selectedState ?? '',
          'latitude':_latitude,
          'longitude':_longitude,
          'country': selectedCountry ?? '',
          'numberOfHalls': numberOfHalls.toString(),
        };
        var jsonData = jsonEncode(venueDetails);
        print('venuedata ${venueDetails}');

    
      var httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      var request = await httpClient.postUrl(
        Uri.parse('http://$ipAddress:443/venue/home/screen'),
      );
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonData);
      var response = await request.close().timeout(Duration(seconds: 60));
      

     if (response.statusCode == 200) {
      // Venue details stored successfully
      print('Venue details stored successfully');
      // Display a success message in the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Venue details stored successfully')),
      );
    } else {
      // Error storing venue details
      print('Error storing venue details');
      // Display a failure message in the UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to store venue details')),
      );
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
    // Display a generic error message in the UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred')),
    );
  }
  }

  int _selectedIndex = 0;

 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        // Profile icon index
        // Navigate to the profile page
        NavigationUtils.navigateToPage(context, OverlayFilter());
      }
      else  if (_selectedIndex == 3) {
        // Profile icon index
        // Navigate to the profile page
        NavigationUtils.navigateToPage(context, ProfileScreen());
      }
       else  if (_selectedIndex == 0) {
        // Profile icon index
        // Navigate to the profile page
        // NavigationUtils.navigateToPage(context, VenueExplore());
      }
      else  if (_selectedIndex == 2) {
        // Profile icon index
        // Navigate to the profile page
        // NavigationUtils.navigateToPage(context,OrderScreen());
      }
    });
  }

 String? _validateVenueName(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _venuenameValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _venuenameValidationError = null;
      });
    }
    return null;
  }

String? _validatenumberofhalls(String value) {
    // Try parsing the input as an integer
    if (int.tryParse(value) == null) {
      setState(() {
        _venuenumberofhallsValidationError = 'Enter a valid number';
      });
    } else {
      setState(() {
        _venuenumberofhallsValidationError = null;
      });
    }
    return null;
  }

  String? _validateVenueAddress(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z0-9\s\.,\-#]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _venueaddressValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _venueaddressValidationError = null;
      });
    }
    return null;
  }

  String? _validateVenuelocation(String value) {
    // Adjust the regular expression to match the format of your address
    final RegExp addressRegex = RegExp(
        r'^[a-zA-Z0-9\s\.,\-#]+$'); // Allow letters, numbers, spaces, commas, periods, hyphens, and pound signs

    if (!addressRegex.hasMatch(value)) {
      setState(() {
        _venuelocationValidationError =
            'Enter a valid location'; // Update error message as needed
      });
    } else {
      setState(() {
        _venuelocationValidationError = null;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
       appBar: AppBar(
        elevation:0,
        backgroundColor: Colors.white.withOpacity(0.1),
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
        title:Text('Venue Details',style: TextStyle(color: Colors.black),)
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height * 0.06,
            child: Image.asset(
              'assets/images/Vectorbg1.png',
            ),
          ),
             Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: paddingleft,
                top: MediaQuery.of(context).size.height * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Venue Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: paddingleft),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _venuenameValidationError != null
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.4),
                            )),
                        child: Row(
                          children: [
                            Icon(
                              Icons.home_filled,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _venuenameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Venue Name",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // Call the validation method when the text changes
                                  _validateVenueName(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                SizedBox(height: 15),
               Container(
                      alignment: Alignment.topLeft,
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
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.only(left: paddingleft),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _venueaddressValidationError != null
                                        ? Colors.red
                                        : Colors.grey.withOpacity(0.4),
                                  )),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _venueaddressController,
                                      decoration: InputDecoration(
                                        hintText: "Enter Address",
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        // Call the validation method when the text changes
                                        _validateVenueAddress(value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  color: _venuelocationValidationError != null
                                      ? Colors.red
                                      : Colors.grey.withOpacity(0.4),
                                )),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Location Here",

                                      // suffixIcon: IconButton(
                                      //   icon: Icon(Icons.search),
                                      //   onPressed: () {
                                      //     _searchLocation(_searchController.text);
                                      //   },
                                      // ),
                                    ),
                                    onChanged: (value) {
                                      _getSuggestions(value);
                                      _validateVenuelocation(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _suggestions.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    left: paddingleft,
                                    top: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: _suggestions
                                        .map((suggestion) => GestureDetector(
                                              onTap: () {
                                                _searchController.text =
                                                    suggestion;
                                                _searchLocation(suggestion);
                                                _onSuggestionTapped(suggestion);
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
                    SizedBox(height: 15),
                    Text(
                      'Add Number Of Halls',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.only(left: paddingleft),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: _venuenumberofhallsValidationError != null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _numberofhallsController,
                              decoration: const InputDecoration(
                                hintText: "Enter Number Of Halls",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                setState(() {
                                  numberOfHalls = int.tryParse(value) ?? 0;
                                  _validatenumberofhalls(value);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                SizedBox(height: 10),
                Center(
                  child: CustomButtonSmall(
                    onPressed: () {
                       _validateVenueName(_venuenameController.text);
                            _validateVenueAddress(_venueaddressController.text);
                            _validateVenuelocation(_searchController.text);
                            _validatenumberofhalls(
                                _numberofhallsController.text);
                            _saveLocation(
                                _selectedPlace, _latitude, _longitude);
                            if (_venuenameValidationError != null ||
                                _venueaddressValidationError != null ||
                                _venuelocationValidationError != null ||
                                _venuenumberofhallsValidationError != null) {
                              // Display a Snackbar if any validation error exists
                              showError(context, 'Enter All Feilds');
                            } else {
                              // All fields are valid, navigate to the other page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FormPage(numberOfHalls: numberOfHalls),
                                ),
                              );
                            }
                      _saveLocation(_selectedPlace, _latitude, _longitude);
                      _sendVenueDetails();
                      // if (numberOfHalls > 0) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           FormPage(numberOfHalls: numberOfHalls),
                      //     ),
                      //   );
                      // } else {
                      //   // Handle case when no halls are entered
                      // }
                    },
                    text: 'GO',
                  ),
                ),
              ],
            ),
          ),
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
