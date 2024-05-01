import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/logout.dart';
import 'package:venue/screens/otp_page.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/vendor/vendor_register.dart';
import 'package:venue/screens/reset_password.dart';
import 'package:venue/screens/venue/home_screen.dart';
import 'package:venue/screens/venue/venue_register.dart';
import 'package:venue/screens/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io'; 
import 'package:venue/components/token_manager.dart';
class VenueLoginScreen extends StatefulWidget { 
  //const LoginScreen({super.key});
   final String? responseBody; //  optional

  const VenueLoginScreen({Key? key, this.responseBody}) : super(key: key);
 
  @override
  State<VenueLoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<VenueLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String ipAddress=Configip.ip;
  final TokenManager _tokenManager = TokenManager();
  bool _obscureText = true;
  bool _rememberMe = false;
  String? _emailValidationError;
  String? _passwordValidationError;
  String? _passwordController1error;
  void _showValidationRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Validation Rules.',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Password should contain at least 10 characters.',
                style: TextStyle(
                    color: _passwordController.text.length >= 10
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '2. Password should contain at least one uppercase letter.',
                style: TextStyle(
                    color: _passwordController.text.contains(RegExp(r'[A-Z]'))
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '3. Password should contain at least one special character.',
                style: TextStyle(
                    color: _passwordController.text
                            .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  } 


   String? _validateEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      // showError(context, 'Enter A Valid Email');
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
      // showSuccess(context, 'Email is Valid');
      return null;
    }
    // No error
  }
String? _validatePassword(String value) {
    if (value.length < 10) {
      // showError(context, 'Password Should Atleast Contain 10 Characters');
      setState(() {
        _passwordValidationError =
            'Password Should Atleast Contain 10 Characters';
        _passwordController1error =
            'Password Should Atleast Contain 10 Characters';
      });

      return null;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      // showError(context, 'Password Should Contain Atleast One Uppercase Letter');
      setState(() {
        _passwordValidationError =
            'Password Should Contain Atleast One Uppercase Letter';
      });
      return null;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      // showError(context, 'Password Should Contain Atleast One Special Character');
      setState(() {
        _passwordValidationError =
            'Password Should Contain Atleast One Special Character';
      });
      return null;
    } else {
      // If all conditions are met, clear the error message and show success message
      setState(() {
        _passwordValidationError = null;
      });
      // _passwordValidationError = 'All Validations Are Met';

      // showSuccess(context, 'All validations Are Met');
      return null;
    }
  }
Future<void> venueLogin() async {
    // Extract email
    // and password from text controllers
    print("called");
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Create JSON data to send in the request body
    Map<String, String> userData = {
      'email': email,
      'password': password,
    };

    // Encode the data as JSON
    String jsonData = jsonEncode(userData);
    print('jsonData ${jsonData}');

    try {
      // Make the HTTP POST request to your backend
       var httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    var request = await httpClient.postUrl(
      //Uri.parse('https://34.125.168.131:8000/login'),
       Uri.parse('http://$ipAddress:443/venue/login'),
    );
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonData);
    var response = await request.close().timeout(Duration(seconds: 60));
      // Check the response status code
      var responseData = await response.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        // Login successful, handle the response data
        
      Map<String, dynamic> responseMap = jsonDecode(responseData);
      String token = responseMap['token']; // Extract token from response
      // Perform actions based on successful login
      print(responseMap['userType']);
      // String fullname = responseMap['fullname']; // Extract fullname from response
       // Print fullname
     // print('Fullname: $fullname');

      await _tokenManager.saveToken(token);
      print('Login successful, Token: $token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeVenue()),
        );
      } else {
  // Login failed, handle the error
  Map<String, dynamic> errorMap = jsonDecode(responseData);
  String errorMessage = errorMap['error']; // Extract error message from response
  print('Login failed: $errorMessage');
  // Display error message on the frontend
  // For example, you can use a Snackbar to show the error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Login failed: $errorMessage'),
      backgroundColor: Colors.red,
    ),
  );
  }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error occurred during login: $error');
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
                        top: MediaQuery.of(context).size.height * 0.27,
                        left: paddingleft),
                    child: Text(
                      "Sign in",
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
                          color: _emailValidationError != null
                              ? Colors.red
                              : Colors.grey.withOpacity(0.4),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                 Row(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: paddingleft),
                        child: Container(
                          padding: EdgeInsets.only(left: paddingleft),
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _passwordValidationError != null
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.4),
                            ),
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
                                  obscureText: _obscureText,
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
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          _showValidationRules(context);
                        },
                        child: Container(
                          child: Center(
                            child: Icon(
                              Icons.lock_open_rounded,
                              color: Colors.grey,
                            ),
                          ),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _passwordValidationError != null
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      right: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            NavigationUtils.navigateToPage(
                              context,
                              OtpPage(),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            _validateEmail(_emailController.text);
                             _validatePassword(_passwordController.text);
                            // Check if there's any validation error
                            if (_emailValidationError == null) {
                              // If no validation error, proceed with signing in
                               venueLogin();
                              // NavigationUtils.navigateToPage(
                              //     context, WelcomeScreen());
                            }
                          },
                          text: 'SIGN IN',
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
                            'Login with Google',
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
                                text: '  Sign up',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    NavigationUtils.navigateToPage(
                                      context,
                                      SignupVenue(),
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
