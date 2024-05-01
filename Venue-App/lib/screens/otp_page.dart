import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/snack_bar.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/otp_popup.dart';



class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController _emailController = TextEditingController();
  String? _emailValidationError;
   String ipAddress=Configip.ip;

  // Email validation method
  String? _validateEmail(String value) {
    final RegExp emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() {
        _emailValidationError = 'Enter a valid email address';
      });
      return 'Enter a valid email address';
    } else {
      setState(() {
        _emailValidationError = null;
      });
      return null;
    }
  }

  Future<void> _sendOTP() async {
    print("called");
    final String email = _emailController.text.trim();
    final Uri url = Uri.parse('http://${ipAddress}:443/sendOtp'); // Replace with your backend endpoint
    final Map<String, String> body = {'email': email};

    try {
      final response = await http.post(
        url,
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String message = responseData['message'];
        final int otp = responseData['otp']; // You might not need this in the UI
        // Show a success message or navigate to OTP entry screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show an error message if OTP sending failed
        final String errorMessage = json.decode(response.body)['error'];
        showError(context, errorMessage);
      }
    } catch (error) {
      // Handle network errors or exceptions
      print('Error occurred while sending OTP: $error');
      showError(context, 'Failed to send OTP. Please try again.');
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
                        top: MediaQuery.of(context).size.height * 0.25,
                        left: paddingleft),
                    child: const Text(
                      "Forgot Password",
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
                    child: Text(
                      'Please enter your email address \nto request a password reset',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          onPressed: () {
                            // Validate email before showing OTP popup
                            String? emailError = _validateEmail(_emailController.text);
                            if (emailError == null) {
                              // Email is valid, show OTP popup
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>  OtpPopup(email: _emailController.text),
                              );
                            } else {
                              // Show error message for invalid email
                              showError(context, emailError);
                            }
                            _sendOTP();
                          },
                          text: 'SEND',
                          
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
                  // Handle navigation to previous screen
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