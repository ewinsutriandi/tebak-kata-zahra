import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tebak_kata/model/word.dart';

class WordsProvider {
  static Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  static Future<List<WordGuess>>  asmaulHusnaList() async{      
    String path = 'assets/words/asmaulhusna.json';      
    return await loadAsset(path)
      .then((value){        
        List<WordGuess> wordList = [];
        var obj = jsonDecode(value);        
        List<dynamic> arr = obj['names'];        
        print(arr.runtimeType);                
        for (final Map<String,dynamic> row in arr) {          
          WordGuess wg = new WordGuess(row['Nama'], [row['Indonesia']]);
          wordList.add(wg);
        }        
        wordList.shuffle();
        return wordList;
      }); 
  }
  
  static Future<List<WordGuess>>  malaikatList() async{      
    String path = 'assets/words/malaikat.json';      
    return await loadAsset(path)
      .then((value){        
        List<WordGuess> wordList = [];
        var obj = jsonDecode(value);        
        List<dynamic> arr = obj['malaikat'];        
        print(arr.runtimeType);                
        for (final Map<String,dynamic> row in arr) {          
          WordGuess wg = new WordGuess(row['Nama'], [row['Tugas']]);
          wordList.add(wg);
        }        
        wordList.shuffle();
        return wordList;
      }); 
  }

  static Future<List<WordGuess>>  quranList() async{      
    String path = 'assets/words/alquran.json';      
    return await loadAsset(path)
      .then((value){        
        List<WordGuess> wordList = [];
        var obj = jsonDecode(value);        
        List<dynamic> arr = obj['alquran'];        
        print(arr.runtimeType);                
        for (final Map<String,dynamic> row in arr) {          
          WordGuess wg = new WordGuess(row['nama'], 
            [row['nomor'],row['arti_nama'],row['jumlah_ayat'],row['tempat_turun']]);
          wordList.add(wg);
        }        
        wordList.shuffle();
        return wordList;
      }); 
  }

  static Future<List<WordGuess>>  prophetList() async{      
    String path = 'assets/words/nabirasul.json';      
    return await loadAsset(path)
      .then((value){        
        List<WordGuess> wordList = [];
        var obj = jsonDecode(value);        
        List<dynamic> arr = obj['prophets'];        
        print(arr.runtimeType);                
        for (final Map<String,dynamic> row in arr) {
          String nama = row['Nama'];          
          int maxClue = 10;
          List<String> clues = [];
          for (int i=0; i < maxClue; i++) {
            String key = "clue"+i.toString();
            if (row.containsKey(key)) {
              clues.add(row[key]);
            }
          }
          WordGuess wg = new WordGuess(nama,clues);
          wordList.add(wg);
        }        
        wordList.shuffle();
        return wordList;
      }); 
  }
}
