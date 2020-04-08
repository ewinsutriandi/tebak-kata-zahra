import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tebak_kata/components/wordbox.dart';
import 'package:tebak_kata/engine/tebak_kata.dart';


const List<String> progressImages = const [
  'assets/img/wrong0.png',
  'assets/img/wrong1.png',
  'assets/img/wrong2.png',
  'assets/img/wrong3.png',
  'assets/img/wrong4.png',
  'assets/img/wrong5.png',
  'assets/img/wrong6.png',
  'assets/img/lose.png',
];

const String keyFXEnable = 'SoundFXEnabled';
const String winAudio = 'assets/sounds/win.ogg';
const String gameOverAudio = 'assets/sounds/game_over.ogg';
const String correctAudio = 'assets/sounds/correct.ogg';
const String wrongAudio = 'assets/sounds/wrong.ogg';

const String victoryImage = 'assets/img/win.png';

const List<String> alphabet = const [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
  'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
];

const TextStyle newGameStyle = TextStyle(
  fontSize: 17.0,
  letterSpacing: 2.0,
  color: Colors.white
);

const TextStyle keyboardStyle = TextStyle(
  fontSize: 15.0,
  letterSpacing: 1.0,
  color: Colors.white
);

const TextStyle activeWordStyle = TextStyle(
  fontSize: 19.0,
  letterSpacing: 5.0,
);

const TextStyle clueWordStyle = TextStyle(
  fontSize: 19.0,
  letterSpacing: 2.0,
);

class TebakKataPage extends StatefulWidget {
  final GameTebakKata _engine;
  TebakKataPage(this._engine);
  @override
  State<StatefulWidget> createState() => _TebakKataPageState();
}

class _TebakKataPageState extends State<TebakKataPage> {
  bool _showNewGame;
  bool _enableSound = true;
  String _activeImage;
  String _activeWord;
  String _activeClue;
  String _lastGameStatus;
  AssetsAudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();    
    widget._engine.onUpdateWord.listen(this._updateWordDisplay);
    widget._engine.onUpdateClue.listen(this._updateClueDisplay);
    widget._engine.onWrong.listen(this._updateReactionImage);
    widget._engine.onWin.listen(this._win);
    widget._engine.onLose.listen(this._gameOver);
    loadSharedPrefAndStartGame();
  }

  Future<void> loadSharedPrefAndStartGame() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool sfxenable = prefs.getBool(keyFXEnable);
    sfxenable ==  null ? _enableSound = true : _enableSound = sfxenable;
    print(_enableSound);    
    this._newGame();
  }

  void _updateWordDisplay(String word) {
    _playSoundFX(correctAudio);
    this.setState(() {
      _activeWord = word;
    });
  }

  void _updateClueDisplay(String clue) {
    this.setState(() {
      _activeClue = clue;
    });
  }

  void _updateReactionImage(int wrongGuessCount) {
    _playSoundFX(wrongAudio);
    this.setState(() {
      _activeImage = progressImages[wrongGuessCount];
    });
  }

  void _win(String winStatus) {
    _playSoundFX(winAudio);    
    this.setState(() {
      _activeImage = victoryImage;
      _lastGameStatus = winStatus;
      this._showNewGame = true;
    });
  }

  void _gameOver([_]) {
    _playSoundFX(gameOverAudio);
    this._showNewGame = true;
  }

  void _playSoundFX(String asset) {
    print(_enableSound);
    if (_enableSound) {
      _audioPlayer = AssetsAudioPlayer();
      _audioPlayer.open(asset);
      _audioPlayer.play();
    }
  }

   @override
  void dispose() {
    _audioPlayer = null;
    super.dispose();
  }

  void _newGame() {
    _lastGameStatus = '';    
    widget._engine.newGame();
    this.setState(() {
      _activeWord = '';
      _activeClue = '';
      _activeImage = progressImages[0];
      _showNewGame = false;
    });
  }

  Widget _bottomContent() {
    Widget bottom;
    double inset = 10;
    if (_showNewGame) {
      inset = 40;
      bottom = _finishedGameUI();       
    } else {
      bottom = _keyBoard();
    }
    return Padding(
      padding: EdgeInsets.only(bottom:inset),
      child: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(children: <Widget>[
                new Container(
                  alignment: Alignment.center,                  
                  child: _clue(),
                ),
                new Align(alignment: Alignment.bottomRight,
                  child: _toggleSound()
                )
              ]
            ),
            _reactionSmile(),            
            _wordDisplay(),            
            Center(
                child: _bottomContent(),
            ),            
          ],
        ),
      );  
  }
  Widget _toggleSound() {
    Icon icon;
    _enableSound ? icon = Icon(Icons.volume_up,color: Colors.green,) : icon = Icon(Icons.volume_off,color:Colors.grey,);
    print(icon);
    return Material(
      color: Colors.transparent,
      child: IconButton(
            icon: icon,
            //color: Colors.transparent,
            onPressed: () async { 
              _enableSound = !_enableSound;              
              setState(() {                
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool(keyFXEnable, _enableSound); 
            }
      ),
    );
  }
  Widget _clue() {
    String clue = _showNewGame ? ' ' : _activeClue;    
    return Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(clue, style: clueWordStyle,textAlign: TextAlign.center,),
              ),
            );
  }
  Widget _reactionSmile() {
    return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.green
                ),
                child: Image.asset(
                  _activeImage
                )                
              )            
            );
  }
  Widget _wordDisplay() {
    return Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                //child: Text(_activeWord, style: activeWordStyle),
                child: WordBox(word: _activeWord,),
              ),
            );
  }  
  Widget _finishedGameUI() {
    return Column(        
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(_lastGameStatus, style: activeWordStyle),
            ),              
          ),
          MaterialButton(
            child: Text('Coba Lagi',style: newGameStyle,),
            padding: EdgeInsets.all(9),
            color: Colors.green,
            splashColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7)
            ),
            onPressed: this._newGame,
          )
        ],        
      );
  }
  Widget _keyBoard() {
    final Set<String> lettersGuessed = widget._engine.lettersGuessed;
      return Wrap(
        //spacing: 0.5,
        //runSpacing: 0.5,
        alignment: WrapAlignment.center,
        children: alphabet.map((letter) => MaterialButton(
          child: Text(letter,style: keyboardStyle,),
          minWidth: 32,
          //padding: EdgeInsets.all(0.2),
          color: Colors.brown,
          splashColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9)
            ),
          onPressed: lettersGuessed.contains(letter) ? null : () {
            widget._engine.guessLetter(letter);
          },
        )).toList(),
      );
  }  
}