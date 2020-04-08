import 'package:flutter/cupertino.dart';

class LetterBox extends StatefulWidget {
  final String letter;
  LetterBox({this.letter});
  @override
  _LetterBoxState createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  bool isGuessed = false;  
  @override
  Widget build(BuildContext context) {    
    return SizedBox(
      width: 75.0,
      height: 75.0,
      child: isGuessed? Text(widget.letter): Text("?")
    );
  }
}