import 'package:flutter/cupertino.dart';
import 'package:tebak_kata/components/letterbox.dart';

class WordBox extends StatelessWidget {
  final String word;
  WordBox({this.word});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0.5,
      runSpacing: 0.5,
      children: 
        word.split('').map((letter) {
          return LetterBox(
            letter: letter
          );
        }).toList()           
      );      
  }

}