import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
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
  int numberOfHalls = 0;
  String? selectedCity;
  List<String> cityList = [
    'Udupi',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
  ];
  String? selectedState;
  List<String> stateList = [
    'karnataka',
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
  String? selectedCountry;
  List<String> countryList = [
    'India',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
  ];

 @override
  void dispose() {
    _searchController.dispose();
    _venuenameController.dispose();
    _venueaddressController.dispose();
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
      

      if (response.statusCode == 201) {
        // Venue details stored successfully
        print('Venue details stored successfully');
      } else {
        // Error storing venue details
        print('Error storing venue details');
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                  'VENUE NAME',
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
                      controller: _venuenameController,
                      decoration: InputDecoration(
                        hintText: "Enter Venue Name",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 202, 200, 200),
                        ),
                        border: InputBorder.none,
                      ),
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
                            controller: _venueaddressController,
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
                                            _searchController.text =
                                                suggestion;
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

                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
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
                        child: Center(
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
                        child: Center(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Select State",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            value: selectedState,
                            onChanged: (String? value) {
                              setState(() {
                                selectedState = value;
                              });
                            },
                            items: stateList.map((String state) {
                              return DropdownMenuItem<String>(
                                value: state,
                                child: Text(state),
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
                        child: Center(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Select Country",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            value: selectedCountry,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCountry = value;
                              });
                            },
                            items: countryList.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'ADD NUMBER OF HALLS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: "Numbers..",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 202, 200, 200),
                        ),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        setState(() {
                          numberOfHalls = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: CustomButtonSmall(
                    onPressed: () {
                      _saveLocation(_selectedPlace, _latitude, _longitude);
                      _sendVenueDetails();
                      if (numberOfHalls > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FormPage(numberOfHalls: numberOfHalls),
                          ),
                        );
                      } else {
                        // Handle case when no halls are entered
                      }
                    },
                    text: 'GO',
                  ),
                ),
              ],
            ),
          ),
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
