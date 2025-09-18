import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/widgets/ErrorMSG/ErrorMSG.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/PhotoWidget.dart';
import 'package:appsme/widgets/InviaMailPage/EmailSendPage.dart';
import 'package:appsme/widgets/SenderFunctions/SenderFunctions.dart';
import 'package:appsme/widgets/parser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RicezioneRicambiPage extends StatefulWidget {
  RicezioneRicambiPage({super.key});
  List<String> FotoPath = <String>[];
  @override
  State<RicezioneRicambiPage> createState() => _RicezioneRicambiPageState();
}

class _RicezioneRicambiPageState extends State<RicezioneRicambiPage> {
  String text = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var text1 = await ParserText.getText("40");
      setState(() {
        text = text1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("App SME"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text(
                "Ricezione Ricambi",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ), // TITOLO
              Padding(padding: EdgeInsets.all(15)),
              Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
              Padding(padding: EdgeInsets.all(20)),
              PhotoWidget(title: "Scatta foto al materiale", text: "Foto Materiale", FotoPath: widget.FotoPath)
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50,
          width: 100,
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Text("Invia Mail"),
            onPressed: () async {
              if (widget.FotoPath.isEmpty) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ErrorMSG(msg: "Devi scattare almeno una foto al materiale ricevuto");
                    });
                return;
              }
              context.read<DatiInviaRicambiAMagazzinoRCProvider>().addFotoRicambi(widget.FotoPath);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmailSendPage(sendFunction: SenderFunctions.EmailSendRicezioneRicambi),
                ),
              );
            },
          ),
        )
      );
  }
}
