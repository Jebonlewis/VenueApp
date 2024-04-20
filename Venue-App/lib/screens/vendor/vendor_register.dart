import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/snack_bar.dart';
import 'package:venue/screens/vendor/branch_details.dart';
import 'package:venue/screens/explore_screen.dart';
//import 'package:venue/screens/login_screen.dart';
import 'package:venue/screens/search_screen.dart';
import 'dart:convert'; // Import this for JSON encoding
import 'package:http/http.dart' as http; // Import the http package
import 'dart:io';

import 'package:venue/screens/vendor/vendor_login.dart';

class SignupVendor extends StatefulWidget {
  const SignupVendor({super.key});

  @override
  State<SignupVendor> createState() => _SignupVendorState();
}

class _SignupVendorState extends State<SignupVendor> {
   String? selectedCategory;
  List<String> CategoryList = [
    'Birthday',
    'Music',
    'Wedding',
    'Corporate',
    
    // Add more cities as needed
  ];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  String? _emailValidationError;
  String? _passwordValidationError;
  String? _confirmPasswordValidationError;
  String? _nameValidationError;

  String? _validateName(String value) {
    // You can adjust the regular expression as per your name validation requirements
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      setState(() {
        _nameValidationError = 'Enter Your Full Name';
      });
    } else {
      setState(() {
        _nameValidationError = null;
      });
    }
    return null;
  }

  String? _validateEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() {
        // Show Snackbar if the name is empty
        //  showSnackbarError('Enter a valid email address');
        // Set the error message for the TextField
        _emailValidationError = 'Enter a Valid Email Address';
      });
      //  showSnackbarError( 'Enter a valid email address'); // Return the error message
    } else {
      // Clear any previous validation error
      setState(() {
        _emailValidationError = null;
      });
    }
    return null; // No error
  }

  String? _validatePassword(String value) {
    if (value.length < 10) {
      setState(() {
        _passwordValidationError =
            'Password Should Atleast Contain 10 Characters';
      });
    } else {
      setState(() {
        _passwordValidationError = null;
      });
    }
    return null;
  }

  String? _validateConfirmPassword(String value) {
    if (value != _passwordController.text) {
      setState(() {
        _confirmPasswordValidationError = 'Passwords do not match';
      });
    } else {
      setState(() {
        _confirmPasswordValidationError = null;
      });
    }
    return null;
  }

  Future<void> vendorsignUp() async {
  //   // Create a JSON object with the user data
       print('called');
  //   var vendorData = {
       var vendorData = {
      'fullname': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'confirmPassword': _confirmPasswordController.text.trim(),
      'serviceType': selectedCategory,
      // Add other necessary data if needed
    };

    var jsonData = jsonEncode(vendorData);
    print('vendordata ${vendorData}');

    try {
      var httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      var request = await httpClient.postUrl(
        Uri.parse('https://192.168.84.84:443/vendor/register'),
      );
      request.headers.set('Content-Type', 'application/json');
      request.write(jsonData);
      var response = await request.close().timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        var responseBody = await response.transform(utf8.decoder).join();
        if (responseBody == 'Verification email sent') {
          setState(() {
            _emailValidationError = null;
            _passwordValidationError = null;
            _confirmPasswordValidationError = null;
            _nameValidationError = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Verification email sent. Please check your inbox.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    responseBody ?? 'An error occurred during registration')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during registration')),
        );
      }
    }catch (error) {
      // Handle network errors or exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during registration')),
      );
        // showSuccess(context, 'An Error Occurred During Registration') ;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double paddingleft = screenSize.width * 0.05;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.16,
                        left: paddingleft),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
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
                            Icons.person,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: "Full name",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateName(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _nameValidationError != null
                        ? Text(
                            _nameValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
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
                            Icons.mail_rounded,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "abc@email.com",
                                // errorText: _emailValidationError,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateEmail(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _emailValidationError != null
                        ? Text(
                            _emailValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
                      padding: EdgeInsets.only(left: paddingleft),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Your Password",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validatePassword(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _passwordValidationError != null
                        ? Text(
                            _passwordValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: Container(
                      padding: EdgeInsets.only(left: paddingleft),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateConfirmPassword(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _confirmPasswordValidationError != null
                        ? Text(
                            _confirmPasswordValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                   SizedBox(
                      height:
                          1), // Add some spacing between the input and the error text
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: paddingleft),
                    child: _nameValidationError != null
                        ? Text(
                            _nameValidationError!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          )
                        : SizedBox(), // Use SizedBox to provide an empty widget when there's no error
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                        hintText: "Select Categories",
                        // hintStyle: TextStyle(color: Colors.grey),
                      ),
                      value: selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      items: CategoryList.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            _validateName(_nameController.text);
                            _validateEmail(_emailController.text);
                            _validatePassword(_passwordController.text);
                            _validateConfirmPassword(
                                _confirmPasswordController.text);
                            // Check if there's any validation error
                            if (_nameValidationError == null &&
                                _emailValidationError == null &&
                                _passwordValidationError == null &&
                                _confirmPasswordValidationError == null) {
                              // If no validation error, proceed with signing in
                              // signUp();

                              // NavigationUtils.navigateToPage(
                              //     context, ExploreScreen());
                            }
                            // NavigationUtils.navigateToPage(context, BranchDetails());
                          vendorsignUp();
                          },
                          text: 'SIGN UP',
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Text(
                          'OR',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text(
                            'Sign up with Google',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 10, // Set the elevation value here
                            shadowColor: Color.fromRGBO(116, 117, 117, 1)
                                .withOpacity(0.2),
                            minimumSize: Size(
                              271,
                              58,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        FilledButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/facebook_logo.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text(
                            'Login with Facebook',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 10, // Set the elevation value here
                            shadowColor: Color.fromRGBO(116, 117, 117, 1)
                                .withOpacity(0.2),
                            backgroundColor: Colors.white,
                            minimumSize: Size(
                              271,
                              58,
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        RichText(
                          text: TextSpan(
                            text: 'Dont have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '  Sign in',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    NavigationUtils.navigateToPage(
                                      context,
                                      VendorLoginScreen(),
                                    );
                                  },
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.10,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  NavigationUtils.navigateToPage(
                    context,
                    VendorLoginScreen(),
                  );
                },
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.06,
              child: Image.asset(
                'assets/images/Vectorbg1.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
