import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaRisultati.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'puntoVendita.dart';

class ListaPage extends StatefulWidget {
  ListaPage({super.key, required this.nextRoute});
  
  MaterialPageRoute? nextRoute;
  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  List<String> tiles = [];
  PuntoVendita? chosenPuntoVendita;
  ListaRisultati ll = ListaRisultati(
                      heightListPercentage: 0.6);
  @override
  Widget build(BuildContext context) {
    tiles.addAll(List<String>.generate(10, (index) => index.toString()));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Gestore Ricambi")),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                //Form
                children: [
                  Text(
                    "Punto Vendita",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                  ), // TITOLO
                  Container(
                    padding: EdgeInsets.all(10),
                  ),
                  ll
                ],
              ), //FINE Form
            ],
          ),
        ),
        floatingActionButton: Container(
          height: 50,
          width: 100,
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              if (ll.selectedPuntoVendita == null) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Devi scegliere almeno un punto vendita"),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('Chiudi'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              } else {
                context
                    .read<DatiLuogoProvider>()
                    .updateLuogo(ll.selectedPuntoVendita!
                        .puntoVenditaFormattato());

                if(widget.nextRoute != null){
                  Navigator.of(context).push(widget.nextRoute!);
                }
              }
            },
            child: Text("Avanti", style: TextStyle(fontSize: 14)),
          ),
        ));
  }
}
