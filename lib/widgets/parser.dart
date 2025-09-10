import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ParserText {
  static String txtPathRicambio = 'assets/text/fileRicambio.xml';
  static String txtPathRicambioSpostare =
      'assets/text/fileRicambioSpostare.xml';
  static String placeholder = '???';

  static String parserText(
      List<String> arrTxtReplace, String txtFile, String placeholder) {
    int counter = 0;
    while (txtFile.length >= counter + placeholder.length) {
      int start = counter;
      int end = counter + placeholder.length;

      if (arrTxtReplace.isNotEmpty &&
          txtFile.substring(start, end) == placeholder) {
        txtFile = txtFile.replaceRange(start, end,
            arrTxtReplace.first); //sostituisco la parola 0 nel placeholder
        arrTxtReplace.removeAt(0); //pop dall array
      } else if (arrTxtReplace.isEmpty &&
          txtFile.substring(start, end) == placeholder) {
        txtFile.replaceRange(start, end, "");
      }

      counter++;
    }
    return txtFile;
  }

  Future<void> send(BuildContext context, String TOAddr, String CCAddr,
      String body, String subject, List<String> attachmentPaths) async {
    List<String> TOaddresses = [];
    TOaddresses.addAll(TOAddr.split(","));
    List<String> CCaddresses = [];
    CCaddresses.addAll(CCAddr.split(","));
    final Email email = Email(
      recipients: TOaddresses,
      cc: CCaddresses,
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
