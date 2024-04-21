// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';  // Import jwt_decoder package
// import 'package:venue/screens/choose_screen.dart';
// import 'package:venue/screens/explore_screen.dart';
// import 'package:venue/screens/logout.dart';
// import 'package:venue/screens/overlay_filter.dart';
// import 'package:venue/screens/search_screen.dart';
// import 'package:venue/screens/splash_screen.dart';
// import 'package:venue/screens/welcome_screen.dart';
// import 'package:venue/certificate_manager.dart';
// import 'package:venue/screens/login_screen.dart';
// import 'package:venue/components/token_manager.dart';
// import 'dart:convert';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized before async operations

//   // Load certificates
//   await CertificateManager.loadCertificates();

//   // Check if a token exists
//   String? token = await TokenManager().getToken();
//   print(token);
//   runApp(MyApp(token: token));
// }

// class MyApp extends StatelessWidget {
//   final String? token;

//   const MyApp({Key? key, this.token}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     bool isUserToken = false; 

//     if (token != null) {
//       // Decode the token to check its contents using jwt_decoder
//       Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
//       String? userType = decodedToken['userType'];
//       print(userType);
//       String? fullname = decodedToken['fullname'];
//       print('fullname ${fullname}');
//       if (userType == 'user') {
//         isUserToken = true;
//       }
//     }

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Venue App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // Define routes based on token type
//       initialRoute: token != null ? (isUserToken ? '/home' : '/vendorHome') : '/login',
//       routes: {
//         '/home': (context) => LogoutScreen(), // User home screen
//         '/vendorHome': (context) => OverlayFilter(), // Vendor home screen
//         '/login': (context) => ChooseScreen(),
//         // Add more routes as needed
//       },
//       // Handle unknown routes (optional)
//       onUnknownRoute: (settings) {
//         return MaterialPageRoute(builder: (context) => SplashScreen());
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:venue/certificate_manager.dart';
import 'package:venue/screens/vendor/additem_details.dart';
import 'package:venue/screens/vendor/branch_details.dart';
import 'package:venue/screens/choose_screen.dart';
import 'package:venue/screens/display_images.dart';
import 'package:venue/screens/explore_screen.dart';
import 'package:venue/screens/logout.dart';
import 'package:venue/screens/overlay_filter.dart';
import 'package:venue/screens/search_screen.dart';
import 'package:venue/screens/splash_screen.dart';
import 'package:venue/screens/vendor/vendor_login.dart';
import 'package:venue/screens/venue/form_screen.dart';
import 'package:venue/screens/venue/home_screen.dart';
import 'package:venue/screens/welcome_screen.dart';
import 'package:venue/screens/vendor/vendor_register.dart';
import 'package:venue/screens/venue/form_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized before async operations

  // Load certificates
  await CertificateManager.loadCertificates();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Venue App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/userHome': (context) => ExploreScreen(), // User home screen
        '/vendorHome': (context) => BranchDetails(),
        '/venueHome':(context) =>  FormPage(numberOfHalls: 3), // Vendor home screen
        '/chooseScreen': (context) => ChooseScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => SplashScreen());
      },
    );
  }
}