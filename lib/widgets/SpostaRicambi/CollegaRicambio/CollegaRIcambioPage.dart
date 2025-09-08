import 'package:appsme/widgets/InserisciCollega/InserisciCollega.dart';
import 'package:appsme/widgets/InstallazioneRicambi/InviaMail/InviaMail.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollegaRicambio extends StatefulWidget {
  CollegaRicambio({Key? key}) : super(key: key);
  String? dropdownValue = null;
  List<Collega> colleghi = [];
  @override
  State<CollegaRicambio> createState() => _CollegaRicambioState();
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class _CollegaRicambioState extends State<CollegaRicambio> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
        FirebaseFirestore.instance.collection('0').get().then(
          (value) {
            var item = value.docs[0];
            List<Map<String,dynamic>> itemJson = [];
            
            int i = 0;
            while(item.data()[i.toString()] != null){
              if(item.data()[i.toString()]['NOME'] != ""){ //AGGIUNGO SOLO SE I CAMPI SONO PIENI
                widget.colleghi.add(Collega.fromJson(item.data()[i.toString()]));
              }
                i++;
            }
            setState(() {});
          }
        );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Inserisci il nome del Collega per il ricambio",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                ),
                InserisciCollega(text: "Invia a collega")
              ],
            ),

            Container(
                  //AVANTI-INDIETRO
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red.shade400),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.red.shade700)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Text("Indietro"),
                      )
                    ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => InviaMail())));
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.green.shade400),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.green.shade700)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Text("Invia MAIL"),
                      ))
                ],
              )), //FINE AVANTI-INDIETRO
          ],
        ),
      ),
    );
  }
}
