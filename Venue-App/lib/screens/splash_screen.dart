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

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String? userType = decodedToken['userType'];
      if (userType == 'user') {
        isUserToken = true;
      }
    }

    if (_isTapped) {
      String initialRoute =
          token != null ? (isUserToken ? '/home' : '/vendorHome') : '/chooseScreen';
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
