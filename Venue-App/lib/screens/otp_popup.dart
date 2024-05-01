import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/snack_bar.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/reset_password.dart';

class OtpPopup extends StatefulWidget {
   final String email; // Declare email as a final variable

  // Constructor to initialize email
  OtpPopup({required this.email});
  @override
  _OtpPopupState createState() => _OtpPopupState();
}

class _OtpPopupState extends State<OtpPopup> {
  TextEditingController _otpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String ipAddress=Configip.ip;
  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutes
  String? _emailValidationError;
  Color? _messageColor; // Color for error and success messages

  String? _validateOTP(String value) {
    final RegExp otpRegex = RegExp(r'^\d{6}$'); // Regex for exactly 6 digits
    if (!otpRegex.hasMatch(value)) {
      setState(() {
        _emailValidationError = 'Enter a valid 6-digit OTP';
        _messageColor = Colors.red; // Set error message color
      });
      return 'Enter a valid 6-digit OTP';
    } else {
      setState(() {
        _emailValidationError = null;
        _messageColor = null; // Reset message color
      });
      return null; // No error
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          Navigator.pop(context); // Close the dialog when timer expires
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

 Future<void> _submitOTP() async {
  print('called');
    String enteredOTP = _otpController.text;
    String? otpError = _validateOTP(enteredOTP);

    if (otpError == null) {
      try {
        final response = await http.post(
          Uri.parse('http://$ipAddress:443/validateOtp'), // Replace with your backend endpoint
          body: json.encode({'email': widget.email, 'otp': enteredOTP}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final bool success = responseData['result']['success'];
          final String message = responseData['result']['message'];

          setState(() {
            if (success) {
              _messageColor = Colors.green; // Set success message color
            } else {
              _messageColor = Colors.red; // Set error message color
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                style: TextStyle(color: _messageColor), // Apply message color
              ),
            ),
          );

          if (success) {
            // OTP matched successfully, navigate to reset password page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ResetPassword(email:widget.email)), // Replace ResetPasswordPage() with your actual reset password page
            );
          }
        } else {
          // Show error message if OTP validation failed
          final String errorMessage = json.decode(response.body)['error'];
          print('error $errorMessage');
          showError(context, errorMessage);
        }
      } catch (error) {
        // Handle network errors or exceptions
        print('Error occurred while validating OTP: $error');
        showError(context, 'Failed to validate OTP. Please try again.');
      }
    } else {
      // Handle invalid OTP scenario if needed
      // For example, display an error message
      showError(context, otpError);
    }
  }




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Enter OTP'),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.cancel,
              color: Colors.black,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            
                     
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

                      child:
        
          Center(
            child:
           TextField(
                            controller: _otpController,
                             keyboardType: TextInputType.number,
                            
                              decoration:
                              InputDecoration(
                                hintText: "Enter OTP",
                               contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                             
                                border: InputBorder.none,
                              ),
                               onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateOTP(value);
                              },
                            ),
          ),
          ),
          SizedBox(height: 20),
          Text(
            'Time remaining: ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              _submitOTP();
               String enteredOTP = _otpController.text;
  String? otpError = _validateOTP(enteredOTP);
  if (otpError == null) {
    // If OTP is valid, close the dialog

    Navigator.pop(context);
    // Your further logic after validating OTP
  } else {
    // Handle invalid OTP scenario if needed
    // For example, display an error message
    // showError(context, otpError);
  }
            },
            text: 'Submit',
          ),
        ],
      ),
    );
  }
}