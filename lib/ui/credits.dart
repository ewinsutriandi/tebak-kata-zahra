import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tebak_kata/providers/wordsprovider.dart';

class CreditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: WordsProvider.loadAsset('assets/credits.md'),
      builder: ((context,AsyncSnapshot<String> snapshot){
        if (snapshot.hasData) {
          return SafeArea(child: Markdown(data: snapshot.data));
        } else {
          return CircularProgressIndicator();
        }
      }),
    );
  }
}