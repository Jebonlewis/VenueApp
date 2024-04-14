import 'package:flutter/material.dart';

Widget customTextField({
  required BuildContext context,
  required double paddingleft,
  required IconData icon,
  required String hintText,
}) {
  return Container(
    alignment: Alignment.topLeft,
    padding: EdgeInsets.only(left: paddingleft),
    child: Container(
      padding: EdgeInsets.only(left: paddingleft),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
