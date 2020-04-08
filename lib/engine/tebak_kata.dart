// adaptasi minor dari https://github.com/montyr75/hangman/blob/master/lib/src/hangman.dart
// tambahan pada petunjuk/clue untuk menebak

import 'dart:async';
import 'package:tebak_kata/model/word.dart';

class GameTebakKata {
  static const int hanged = 7;			// number of wrong guesses before the player's demise
  final List<WordGuess> wordList;			// list of possible words to guess
  static const List<String> winPredicate = ['Sempurna!','Hebat!','Keren!','Bagus sekali','Hore kamu bisa!','Akhirnya bisa juga!','Fyuhh, hampir saja!']; 
  final Set<String> lettersGuessed = new Set<String>();
  
  List<String> _wordToGuess;
  List<String> _wordToDisplay;
  List<String> _clues;
  int _wrongGuesses;
  int _wordIdx = 0;

  StreamController<List<String>> _onStart = new StreamController<List<String>>.broadcast();
  Stream<List<String>> get onStart => _onStart.stream;
  
  StreamController<String> _onRight = new StreamController<String>.broadcast();
  Stream<String> get onRight => _onRight.stream;

  StreamController<String> _onUpdateClue = new StreamController<String>.broadcast();
  Stream<String> get onUpdateClue => _onUpdateClue.stream;

  StreamController<String> _onUpdateWord = new StreamController<String>.broadcast();
  Stream<String> get onUpdateWord => _onUpdateWord.stream;
  
  StreamController<int> _onWrong = new StreamController<int>.broadcast();
  Stream<int> get onWrong => _onWrong.stream;
    
  StreamController<String> _onWin = new StreamController<String>.broadcast();
  Stream<String> get onWin => _onWin.stream;

  StreamController<Null> _onLose = new StreamController<Null>.broadcast();
  Stream<Null> get onLose => _onLose.stream;  

  GameTebakKata(this.wordList); 
  
  void newGame() {
    _newWord();
    _wrongGuesses = 0;    
    lettersGuessed.clear();
    _onStart.add(null);
    _onUpdateWord.add(wordForDisplay);
    _onUpdateClue.add(clueForDisplay);
  }

  void shuffleWordList() {
    wordList.shuffle();
  }

  void _newWord() {    
    int idx = _wordIdx % wordList.length;
    WordGuess wordGuess = wordList[idx];    
    _wordToGuess = _getAlphabetOnlyLetters(wordGuess.word.toUpperCase());
    _wordToDisplay = wordGuess.word.toUpperCase().split('');
    print(_wordToGuess);
    _clues = wordGuess.clues;
    _clues.shuffle();
    _wordIdx++;
  }

  bool _isAlphabet(String c) {
    RegExp exp = new RegExp(r"[a-zA-Z]");
    return exp.hasMatch(c);
  }

  List<String>  _getAlphabetOnlyLetters(String text) {    
    List<String> letters = text.split('');
    List<String> result = [];
    letters.forEach((c){
        _isAlphabet(c)? result.add(c) : null;       
      }
    ); 
    return result;
  }

  void guessLetter(String letter) {
    //print('tebakan'+letter+' ori:'+_wordToGuess.join());        
    lettersGuessed.add(letter);
    _onUpdateClue.add(clueForDisplay);
    if (_wordToGuess.contains(letter)) {
      _onRight.add(letter);
      _onUpdateWord.add(wordForDisplay);
      if (isWordComplete) {        
        _onWin.add(winPredicate[_wrongGuesses]);
      }      
    }
    else {
      _wrongGuesses++;
      _onWrong.add(_wrongGuesses);
      if (_wrongGuesses == hanged) {
        //_onChange.add(textsForDisplay);
        _onLose.add(null);
      }
    }
  }

  int get wrongGuesses => _wrongGuesses;
  List<String> get wordToGuess => _wordToGuess;
  String get fullWord => wordToGuess.join();

  String get wordForDisplay {
    List<String> words = [];
    for (int i=0;i< _wordToDisplay.length;i++) {
      String letter = _wordToDisplay[i];
      if (_isAlphabet(letter)) {
        lettersGuessed.contains(letter) ? words.add(letter) : words.add("?");
      } else {
        words.add(letter);
      }
    }
    return words.join();
  } 
    

  String get clueForDisplay => 
    _clues[lettersGuessed.length % _clues.length];
  
  // check to see if every letter in the word has been guessed
  bool get isWordComplete {
    for (String letter in _wordToGuess) {
      if (!lettersGuessed.contains(letter)) {
        print('absent of:'+letter);
        return false;
      }
    }
    return true;
  }
}