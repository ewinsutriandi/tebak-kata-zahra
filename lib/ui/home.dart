import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tebak_kata/engine/tebak_kata.dart';
import 'package:tebak_kata/model/word.dart';
import 'package:tebak_kata/providers/wordsprovider.dart';
import 'package:tebak_kata/ui/credits.dart';
import 'package:tebak_kata/ui/tebak_kata_page.dart';


const TextStyle topicSelect = TextStyle(
  fontSize: 19.0,
  letterSpacing: 5.0,
);

const TextStyle topicButton = TextStyle(
  fontSize: 17.0,
  letterSpacing: 2.0,
  color: Colors.white
);

final List<Future<List<WordGuess>>> wordsProvider = [
  WordsProvider.asmaulHusnaList(),
  WordsProvider.malaikatList(),
  WordsProvider.quranList(),
  WordsProvider.prophetList()
];

final List<String> captions = ['Asmaul Husna','Malaikat & Tugasnya','Surat dalam Al-Qur\'an','Nabi & Rasul'];

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[          
          _gameTitle(),          
          _topicSelectCaption(),
          _topicButtons(context),
          Expanded(
            flex: 1,
            child: Container(),            
          ),
        ],
      )
    );
  }

  Widget _gameTitle() {
    return Expanded(
      flex: 3,        
      child: Container(              
        decoration: BoxDecoration(              
        ),
        child: Image.asset(
          'assets/img/titleart.png',              
        )                
      )            
    );
  }

  Widget _topicSelectCaption() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Center(
        child: Text('Pilih Topik',style: topicSelect,),
      ),
    );
  }

  Widget _topicButtons(context) {
    return Column(              
      mainAxisAlignment: MainAxisAlignment.center,              
      children: 
        captions.map((title) {
          int idx = captions.indexOf(title);
          return Padding(
            padding: EdgeInsets.all(5),
            child: MaterialButton(
              child: Text(
                title,style: topicButton,),
              minWidth: 235,
              padding: EdgeInsets.all(15),
              color: Colors.green,
              splashColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
              ),
              onPressed: () {
                  print(title+': '+idx.toString());
                  _navigateToSubPage(context, idx);
                } 
              )  
            );
          }                 
        ).toList()              
    );
  }

  Widget appBarActions(BuildContext context) {
    return PopupMenuButton(
      onSelected: (Choice c) {
        _selectChoice(context, c);
      },
      itemBuilder: (BuildContext context) {
        return _appBarMenuChoices.map((Choice c) {
          return PopupMenuItem(
            value: c,
            child: Text(c.title),
          );
        }).toList();
      }
    );
  }

  void _selectChoice(BuildContext context,Choice c) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => scaffoldWidget(c.title,c.page)));
  }

  static List<Choice> _appBarMenuChoices = [
    new Choice(title: 'Credits',page:CreditPage()),
    new Choice(title: 'Kirim Saran',page:CreditPage())
  ];

  Future _navigateToSubPage(context,index) async {
    Future<List<WordGuess>> provider = wordsProvider[index];
    String title = captions[index];
    provider.then((value) {
      print('Texts loaded, navigate to '+title+' with word size: '+value.length.toString());
      GameTebakKata engine = GameTebakKata(value);
      TebakKataPage tebakKataPage = new TebakKataPage(engine);      
      Navigator.push(context, MaterialPageRoute(builder: (context) => scaffoldWidget(title,tebakKataPage)));
    });
  }

  Widget scaffoldWidget(String title, Widget page) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[],
        ),
        body: page,
      );
  }

}

class Choice {
  const Choice({this.title, this.icon, this.page});

  final String title;
  final IconData icon;
  final Widget page;
}