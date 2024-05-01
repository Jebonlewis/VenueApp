import 'package:flutter/material.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/components/navigator.dart';
import 'package:venue/components/snack_bar.dart';
import 'package:venue/config.dart';
import 'package:venue/screens/user/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  
  final String email; // Declare email as a final variable

  // Constructor to initialize email
  ResetPassword({required this.email, Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String? _passwordValidationError;
  bool _obscureText = true;
  bool _obscure1Text = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _confirmPasswordValidationError;
  String ipAddress=Configip.ip;
  String? _validatePassword(String value) {
    if (value.length < 10) {
      // showError(context, 'Password Should Atleast Contain 10 Characters');
      setState(() {
        _passwordValidationError =
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

      showSuccess(context, 'All validations Are Met');
      return null;
    }
  }

  String? _validateConfirmPassword(String value) {
    if (value != _passwordController.text) {
      //  showError(context, 'Password Do Not Match');
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

  void _showValidationRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Validation Rules.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
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

  Future<void> _resetPassword() async {
    final String email = widget.email; // Provide the user's email here
    final String newPassword = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    final Uri uri = Uri.parse('http://$ipAddress:443/changePassword');

    try {
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

       if (response.statusCode == 200) {
    // Password reset successful
    final dynamic data = jsonDecode(response.body);
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      final dynamic messageData = data['message'];
      if (messageData is Map<String, dynamic> &&
          messageData.containsKey('message')) {
        final String message = messageData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      }
    }
  } else {
    // Password reset failed
    final dynamic data = jsonDecode(response.body);
    if (data is Map<String, dynamic> && data.containsKey('error')) {
      final String error = data['error'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} catch (e) {
  print('Error occurred: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error occurred while resetting password.'),
      backgroundColor: Colors.red,
    ),
  );
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
                      "Reset Password",
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
                      'Please Reset Your Password',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
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
                                    hintText: "Enter New Password",
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
                            color: _confirmPasswordValidationError != null
                                ? Colors.red
                                : Colors.grey.withOpacity(0.4),
                          )),
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
                              obscureText: _obscure1Text,
                              onChanged: (value) {
                                // Call the validation method when the text changes
                                _validateConfirmPassword(value);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _obscure1Text
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure1Text = !_obscure1Text;
                              });
                            },
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
                            _validatePassword(_passwordController.text);
                            _validateConfirmPassword(
                                _confirmPasswordController.text);
                            _resetPassword();
                          },
                          text: 'CONFIRM',
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
                  // NavigationUtils.navigateToPage(
                  //   context,
                  //   LoginScreen(),
                  // );
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
