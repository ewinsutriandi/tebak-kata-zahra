import 'package:flutter/material.dart';
//import 'package:tebak_kata/components/letterbox.dart';
import 'package:tebak_kata/components/wordbox.dart';
import 'package:tebak_kata/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      //home: HomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {      
      _counter++;
    });
  }

  Widget home() {
    HomePage page = HomePage();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Permainan tebak kata Zahra'),
        actions: <Widget>[
          page.appBarActions(context)
        ],
      ),
      body: page,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Permainan Tebak Kata',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: home(),
    );
  }
  
  Widget buildLegacy(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WordBox(
              word: 'Kucing klang kling'+_counter.toString()
            )
            ,
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),      
    );
  }
}
