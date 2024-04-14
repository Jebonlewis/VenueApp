import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:venue/components/token_manager.dart';
class LogoutScreen extends StatelessWidget {
   // Declare fullname as a parameter

  const LogoutScreen({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    //final storage = FlutterSecureStorage();

    try {
      // Display the fullname in the logout message
      
      String? token = await TokenManager().getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      String? userType = decodedToken['userType'];
      print(userType);
      String? fullname = decodedToken['fullname'];
      print('fullname ${fullname}');
      // Delete the token from secure storage
      await TokenManager().deleteToken();
      print('fullname ${fullname}');
      String message = fullname != null ? '$userType $fullname logged out' : 'Logged out';
      print(message);
      // Display the logout message based on user's full name
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

      // Navigate to login screen based on userType
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      // Handle error
      print('Error during logout: $error');
      // You can display an error message or take appropriate action
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the fullname and userType in the UI or delete them as needed
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logout(context); // Call the logout function
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
