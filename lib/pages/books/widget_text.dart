import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  int fontSize;
  bool isUnderLine;
  final Color color;
   TextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.isUnderLine,
    required this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 3, // space between underline and text
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: isUnderLine?Color(0xFF363f93):Color(0xFFffffff),  // Text colour here
            width: 1.0, // Underline width
          ))
      ),

      child: Text(this.text, style: TextStyle(
        fontSize:this.fontSize.toDouble(),
        // fontFamily: "Avenir",
        fontWeight: FontWeight.w900,
        color:this.color,

      ),),
    );
  }
}
