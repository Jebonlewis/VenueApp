import 'package:flutter/material.dart';


 class NavigationUtils {
  static void navigateToPage(BuildContext context, Widget nextPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }
}