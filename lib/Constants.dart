import 'package:flutter/material.dart';

Color backgroundColor = Color(0xFF1A1A1A);
Color secondaryColor = Color(0xFFFF7357);
Color secondaryDark = Color(0xFFFC5956);
Color iconColor = Color(0xFFE62622);
Color yellowColor = Color(0xFFFFE957);
Color blueColor = Color(0xFF004CFF);
Color sheetColor = Color(0xFF2A2A2A);

CircularProgressIndicator circularProgressIndicator() {
  return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor));
}

LinearProgressIndicator linearProgressIndicator() {
  return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(secondaryColor));
}

Widget listItem({IconData icon, String title, Function onPressed}) {
  return InkWell(
    splashColor: Colors.white.withOpacity(0.1),
    onTap: onPressed,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              SizedBox(width: 18),
              Text(title, style: TextStyle(fontSize: 18, fontFamily: 'Ubuntu'))
            ],
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: iconColor)
        ],
      ),
    ),
  );
}
