// home_venue.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venue/components/custom_button.dart';
import 'package:venue/screens/venue/form_screen.dart';

class HomeVenue extends StatefulWidget {
  const HomeVenue({Key? key});

  @override
  State<HomeVenue> createState() => _HomeVenueState();
}

class _HomeVenueState extends State<HomeVenue> {
  int numberOfHalls = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ADD NUMBER OF HALLS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Numbers..",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 202, 200, 200),
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    setState(() {
                      numberOfHalls = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomButtonSmall(
              onPressed: () {
                if (numberOfHalls > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormPage(numberOfHalls: numberOfHalls),
                    ),
                  );
                } else {
                  // Handle case when no halls are entered
                }
              },
              text: 'NEXT',
            ),
          ],
        ),
      ),
    );
  }
}
