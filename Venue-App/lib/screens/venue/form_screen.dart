// form_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/snack_bar.dart';
// import 'package:venue/screens/venue/explore_venue.dart';

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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
    final TextEditingController  _hotelrulesController=TextEditingController();

  final picker = ImagePicker();
  String?  _priceValidationError;
  String? _hotelnameValidationError;
  String?  _abouthotelValidationError;
  String? _hotelrulesValidationError;
  String? _capacityValidationError;
  String? selectedCity;
  String? selectedCategory;
  String? selectedAvailablity;
  String? selectedVenuetype;
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
  List<String> CategoryList = [
    'Birthday',
    'Wedding',
    'Sounds',
    'Party',
  ];

  List<String> AvailablityList = [
    'Yes',
    'No',
  ];
  List<String> VenuetypeList = [
    'Veg',
    'Non-Veg',
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
 String? _validateHotelName(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _hotelnameValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _hotelnameValidationError = null;
      });
    }
    return null;
  }
String? _validateAboutHotel(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z0-9\s\.,\-#]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _abouthotelValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _abouthotelValidationError = null;
      });
    }
    return null;
  }

  String? _validateHotelRules(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z0-9\s\.,\-#]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _hotelrulesValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _hotelrulesValidationError = null;
      });
    }
    return null;
  }
  String? _validatecapacity(value) {
    // Try parsing the input as an integer
    if (int.tryParse(value) == null) {
      setState(() {
        _capacityValidationError = 'Enter a valid number';
      });
    } else {
      setState(() {
        _capacityValidationError = null;
      });
    }
    return null;
  }
  String? _validateprice(value) {
    // Try parsing the input as an integer
    if (int.tryParse(value) == null) {
      setState(() {
        _priceValidationError = 'Enter a valid number';
      });
    } else {
      setState(() {
        _priceValidationError = null;
      });
    }
    return null;
  }
  String? _validateCategory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a category';
  }
  return null;
}
String? _validateAvailablity(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a availablity';
  }
  return null;
}
String? _validateVenuetype(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a venuetype';
  }
  return null;
}

void _checkFieldsAndNavigate() {
  if (_hotelnameValidationError != null ||
      _abouthotelValidationError != null ||
      _hotelrulesValidationError != null ||
      _capacityValidationError != null ||
      _priceValidationError != null ||
      selectedCategory == null ||
      selectedAvailablity == null ||
      selectedVenuetype == null) {
    // Display a Snackbar indicating that all fields must be filled
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Please fill all fields.'),
    //   ),
    // );
    showError(context, 'Enter All Feilds');
  } else {
    // All fields are filled, navigate to the next screen
    if (widget.hallNumber < widget.numberOfHalls) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormPage(
            numberOfHalls: widget.numberOfHalls,
            hallNumber: widget.hallNumber + 1,
          ),
        ),
      );
    } else {
      // Handle completion, navigate to the next screen, etc.
    }
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
      body: Stack(
        children: [
          // Background Image
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height * 0.01,
            child: Image.asset(
              'assets/images/Vectorbg1.png',
            ),
          ),
      
      SingleChildScrollView(
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
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: paddingleft),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:_hotelnameValidationError != null
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
                                controller: _hotelnameController,
                                decoration: InputDecoration(
                                  hintText: "Enter Hotel Name",
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  // Call the validation method when the text changes
                                  _validateHotelName(value);
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
                    'About Hotel',
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
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:  _abouthotelValidationError != null
                                        ? Colors.red
                                        : Colors.grey.withOpacity(0.4),
                                  )),
                              child:
                                  Expanded(
                                    child: TextFormField(
                                      controller: _abouthotelController,
                                       maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: "Write Something About YOur Hotel",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        // Call the validation method when the text changes
                                        _validateAboutHotel(value);
                                      },
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
                    'Restrictions',
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
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:  _hotelrulesValidationError != null
                                        ? Colors.red
                                        : Colors.grey.withOpacity(0.4),
                                  )),
                              child:
                                  Expanded(
                                    child: TextFormField(
                                      controller: _hotelrulesController,
                                       maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: "Enter Rules And Restrictions",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        // Call the validation method when the text changes
                                        _validateHotelRules(value);
                                      },
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
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: _capacityValidationError != null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _capacityController,
                              decoration: const InputDecoration(
                                hintText: "Enter Capacity",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _validatecapacity(value);
                                });
                              },
                            ),
                          ),
                        ],
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
                            color: selectedCategory == null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          
                          hintText: "Select Category",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      value: selectedCategory,
                     
                        onChanged: (String? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                          validator: _validateCategory,
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
                            color: selectedAvailablity == null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Availablity",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        value: selectedAvailablity,
                        onChanged: (String? value) {
                          setState(() {
                            selectedAvailablity = value;
                          });
                        },
                         validator: _validateAvailablity,
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
                            color: selectedVenuetype == null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )
                    ),
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Venue Type",
                          hintStyle: TextStyle(color: Colors.grey),
                           contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        
                        value: selectedVenuetype,
                        onChanged: (String? value) {
                          setState(() {
                            selectedVenuetype = value;
                          });
                        },
                         validator: _validateVenuetype,
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
          
            SizedBox(height: 15),
            Container(
              alignment: Alignment.topLeft,
            
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
                              color:_priceValidationError != null
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.4),
                            )
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.currency_rupee_sharp,
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _validateprice(value);
                                });
                              },
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
                    _checkFieldsAndNavigate();
                    _validateHotelName(_hotelnameController.text);
                    _validateAboutHotel(_abouthotelController.text);
                    _validateHotelRules(_hotelrulesController.text);
                     _validatecapacity(_capacityController.text);
                     _validateprice(_priceController.text);
                    
                    // if (widget.hallNumber < widget.numberOfHalls) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => FormPage(
                    //           numberOfHalls: widget.numberOfHalls,
                    //           hallNumber: widget.hallNumber + 1),
                    //     ),
                    //   );
                    // } else {
                    //   // Handle completion, navigate to next screen, etc.
                    // }
                  },
                  text: 'NEXT',
                ),
              ),
            ),
          ],
        ),
      ),
        ],
        ),
      ),
        ],
      ),
      floatingActionButton: widget.hallNumber == widget.numberOfHalls
          ? FloatingActionButton.extended(
              onPressed: () {
                //  NavigationUtils.navigateToPage(
                //               context,
                //             VenueExplore(),
                //             );
                
              },
              label: Text('Save'),
              icon: Icon(Icons.save),
            )
          : null,
    );
  }
}
