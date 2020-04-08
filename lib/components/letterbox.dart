import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  LetterBox({this.letter});
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(
      fontSize: 19.0,
      fontWeight: FontWeight.bold,
      color: Colors.white
    );
    return letter != ' ' ? Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: Colors.lime,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          new BoxShadow(
            color: Colors.grey,
            offset: new Offset(1.5, 1.5),
          ),
        ],
      ),
      child: SizedBox(
        width: 27.0,
        height: 27.0,            
        child: Center(
          child: AutoSizeText(letter.toUpperCase(),style: style)
        ))        
    ):Text('  ');          
  }
}