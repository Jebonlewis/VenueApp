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
  //await CertificateManager.loadCertificates();
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
        //'/vendorHome': (context) => LogoutScreen(),
        //'/vendorHome': (context) => DisplayImages(email: 'jebontarunlewis63@gmail.com'),
       // '/venueHome':(context) =>  FormPage(numberOfHalls: 3), 
       //'/vendorHome':(context) =>  LogoutScreen(),
       '/venueHome':(context) =>  LogoutScreen(),
        '/chooseScreen': (context) => ChooseScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => SplashScreen());
      },
    );
  }
}