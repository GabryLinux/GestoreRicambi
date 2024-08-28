import 'dart:io';

import 'package:flutter/services.dart';

class ParserText{
  static String txtPathRicambio = 'assets/text/fileRicambio.xml';
  static String txtPathRicambioSpostare = 'assets/text/fileRicambioSpostare.xml';
  static String placeholder = '???';

  static Future<String> parserRicambio(List<String> arrTxtReplace) async{
    String result = "";
    var txtFile = await rootBundle.loadString(txtPathRicambio);

    int counter = 0;
    while(txtFile.length >= counter + placeholder.length){
      int start = counter;
      int end =  counter + placeholder.length;

      if(arrTxtReplace.isNotEmpty && txtFile.substring(start, end) == '???'){
        txtFile = txtFile.replaceRange(start, end, arrTxtReplace.first); //sostituisco la parola 0 nel placeholder
        arrTxtReplace.removeAt(0); //pop dall array

      }else if(arrTxtReplace.isEmpty && txtFile.substring(start, end) == '???'){
        txtFile.replaceRange(start, end, "");
      }

      counter++;
    } 
    return txtFile;
  }

  static Future<String> parserRicambioSpostare(List<String> arrTxtReplace) async{
    String result = "";
    var txtFile = await rootBundle.loadString(txtPathRicambioSpostare);

    int counter = 0;
    while(txtFile.length >= counter + placeholder.length){
      int start = counter;
      int end =  counter + placeholder.length;

      if(arrTxtReplace.isNotEmpty && txtFile.substring(start, end) == '???'){
        txtFile = txtFile.replaceRange(start, end, arrTxtReplace.first); //sostituisco la parola 0 nel placeholder
        arrTxtReplace.removeAt(0); //pop dall array

      }else if(arrTxtReplace.isEmpty && txtFile.substring(start, end) == '???'){
        txtFile.replaceRange(start, end, "");
      }

      counter++;
    } 
    return txtFile;
  }  
}