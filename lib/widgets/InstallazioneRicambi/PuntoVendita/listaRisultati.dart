import 'dart:math';

import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaRisultati extends StatefulWidget {
  ListaRisultati({super.key, required this.heightListPercentage});

  PuntoVendita? selectedPuntoVendita;
  TextEditingController codiceController = TextEditingController();
  num heightListPercentage;
  @override
  State<ListaRisultati> createState() => _ListaRisultatiState();
}

class _ListaRisultatiState extends State<ListaRisultati> {
  List<PuntoVendita> puntiVendita = [];
  List<PuntoVendita> puntiVenditaQuery = [];
  int _selectedIndex = -1;
  @override
  void initState() {
    List<PuntoVendita> puntiV = [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore.instance.collection('0').get().then((value) {
        var item = value.docs[1];
        List<Map<String, dynamic>> itemJson = [];
        int i = 0;
        setState(() {
          while (item.data()[i.toString()] != null) {
            var puntoV = PuntoVendita.fromJson(item.data()[i.toString()]);
            puntiVendita.add(puntoV);
            puntiVenditaQuery.add(puntoV);
            i++;
          }
          debugPrint("Punti Vendita: ${puntiVendita.length}");
        });
      });
    });

    super.initState();
  }

  PuntoVendita? get selectedPuntoVendita => widget.selectedPuntoVendita;

  @override
  Widget build(BuildContext context) {
    
    debugPrint("Selected Punto Vendita: ${puntiVendita.length}");
    return Container(
      //
      child: Column(
        //TEXTINPUT + RISULTATI
        children: [
          TextField(
            //TEXTINPUT
            controller: widget.codiceController,

            onChanged: (value) {
              //var queried
              setState(() {
                puntiVenditaQuery = puntiVendita
                    .where((element) =>
                        element.codDest!
                            .toLowerCase()
                            .startsWith(value.toLowerCase()) ||
                        element.citta!
                            .toLowerCase()
                            .startsWith(value.toLowerCase()) ||
                        value.isEmpty)
                    .toList();
              });
            },
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    widget.codiceController.clear();
                    setState(() {
                      puntiVenditaQuery = puntiVendita;
                    });
                  },
                  icon: Icon(Icons.cancel_outlined)),
              border: OutlineInputBorder(),
              hintText: 'Inserisci Punto Vendita',
              hintStyle: TextStyle(fontSize: 14),
            ),
          ), //FINE TEXTINPUT

          Container(
            padding: EdgeInsets.all(10),
          ),

          Container(
            //Risultati
            height: MediaQuery.of(context).size.height * max(min(widget.heightListPercentage, 1), 0),
            child: ListView.builder(
              itemCount: puntiVenditaQuery.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    selected: index == _selectedIndex,
                    selectedColor: Colors.blue.shade800,
                    selectedTileColor: Colors.lightBlue.shade100,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          puntiVenditaQuery[index].codDest.toString(),
                        ),
                        Text(
                          puntiVenditaQuery[index].citta.toString(),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        debugPrint("Selected Index: $index");
                        _selectedIndex = index;
                        widget.selectedPuntoVendita =
                            puntiVenditaQuery[_selectedIndex];
                      });
                    },
                  ),
                );
              },
            ),
          ) //FINE Risultati
        ],
      ),
    );
  }
}
