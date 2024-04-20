import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Import jwt_decoder package
import 'package:venue/components/token_manager.dart';
import 'package:venue/screens/choose_screen.dart';
import 'package:venue/screens/overlay_filter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    String? token = await TokenManager().getToken();
    bool isUserToken = false;
    bool isVendorToken=false;
    bool isVenueToken=false;

    if (token != null) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  String? userType = decodedToken['userType'];
  print('user type ${userType}');
  if (userType == 'user') {
    isUserToken = true;
  }
  else if (userType == 'vendor') {
    isVendorToken = true;
  }
  else if (userType == 'venue') {
    isVenueToken = true;
  }
}

if (_isTapped) {
  String initialRoute;
  if (token != null) {
    if (isUserToken) {
      initialRoute = '/userHome';
    } else if (isVendorToken) {
      initialRoute = '/vendorHome';
    } else if (isVenueToken) {
      initialRoute = '/venueHome';
    } else {
      initialRoute = '/chooseScreen'; // default route if userType is unknown
    }
  } else {
    initialRoute = '/chooseScreen'; // default route if token is null
  }
  Navigator.pushReplacementNamed(context, initialRoute);
}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Set the tapped flag to true when tapped
          setState(() {
            _isTapped = true;
          });
          // Check token and navigate only if tapped
          checkTokenAndNavigate();
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(55, 75, 248, 1),
                Color.fromRGBO(46, 138, 250, 1)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Vector.png',
                    ),
                    Text(
                      'venue',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/Vectorbg.png',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
