import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeWidget extends StatefulWidget {
  BarcodeWidget({super.key, required this.title});
  String title;
  String text = "";
  TextEditingController codice = TextEditingController();
  @override
  State<BarcodeWidget> createState() => _BarcodeWidgetState();
  String get getCodice => text;
}

class _BarcodeWidgetState extends State<BarcodeWidget> {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      //BARCODE
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(widget.title, style: TextStyle(fontSize: 14)),
            padding: EdgeInsets.all(5),
          ),
          TextField(
            //TEXTINPUT
            controller: widget.codice,
            onChanged: ((value) {
              setState(() {
                widget.text = value;
              });
            }),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 14),
                hintText: 'Inserisci ' + widget.title),
          ), //FINE TEXTINPUT
          OutlinedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    //debugPrint(res);
                    widget.text = res;
                    widget.codice.text = res;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Scannerizza BARCODE",
                  style: TextStyle(fontSize: 14),
                ),
              ))
        ],
      ),
    ); //FINE BARCODE
  }
}
