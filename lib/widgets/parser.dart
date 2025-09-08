
import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

class ParserText{
  static String txtPathRicambio = 'assets/text/fileRicambio.xml';
  static String txtPathRicambioSpostare = 'assets/text/fileRicambioSpostare.xml';
  static String placeholder = '???';

  static Future<String> parserRicambio(List<String> arrTxtReplace) async{
    var txtFile = await rootBundle.loadString(txtPathRicambio);
    return parserText(arrTxtReplace, txtFile, '???');
  }

  static Future<String> parserRicambioSpostare(List<String> arrTxtReplace) async{
    var txtFile = await rootBundle.loadString(txtPathRicambioSpostare);
    return parserText(arrTxtReplace, txtFile, '???');
  }

  static String parserText(List<String> arrTxtReplace, String txtFile, String placeholder) {
    int counter = 0;
    while(txtFile.length >= counter + placeholder.length){
      int start = counter;
      int end =  counter + placeholder.length;

      if(arrTxtReplace.isNotEmpty && txtFile.substring(start, end) == placeholder){
        txtFile = txtFile.replaceRange(start, end, arrTxtReplace.first); //sostituisco la parola 0 nel placeholder
        arrTxtReplace.removeAt(0); //pop dall array

      }else if(arrTxtReplace.isEmpty && txtFile.substring(start, end) == placeholder){
        txtFile.replaceRange(start, end, "");
      }

      counter++;
    } 
    return txtFile;
  }

  

  Future<void> send(BuildContext context, String Addresses, String body, String subject, List<String> attachmentPaths) async {
      List<String> addresses = [];
      addresses.addAll(Addresses.split(","));
      final Email email = Email(
        recipients: addresses,
        body: body,
        subject: subject,
        attachmentPaths: attachmentPaths,
        isHTML: false,
      );

      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
      } catch (error) {
        debugPrint(error.toString());
        platformResponse = error.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(platformResponse),
          ),
        );
      }

      if (!context.mounted) return;
    }

    static Future<String> getText(String ID) async {
    String text = "";
    await FirebaseFirestore.instance
        .collection("TESTI")
        .doc(ID)
        .get()
        .then((value) {
      text = value.data()?['Testo'];
    });
    return text;
  }
}

