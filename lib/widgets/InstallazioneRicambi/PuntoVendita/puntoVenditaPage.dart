import 'dart:convert';

import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoItem.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/RicambioInstallatoPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class puntoVendita extends StatefulWidget {
  puntoVendita({Key? key}) : super(key: key);
  List<PuntoVendita> puntiVendita = [];
  List<PuntoVendita> puntiVenditaQuery = [];  
  TextEditingController codiceController = TextEditingController();
  @override
  State<puntoVendita> createState() => _puntoVenditaState();
}



class _puntoVenditaState extends State<puntoVendita> {
  int _selectedIndex = -1;
  List<String> tiles = [];
  
  @override
  void initState() {
    List<PuntoVendita> puntiV = [];
     WidgetsBinding.instance.addPostFrameCallback((_) async{
        FirebaseFirestore.instance.collection('0').get().then(
          (value) {
            var item = value.docs[1];
            List<Map<String,dynamic>> itemJson = [];
            int i = 0;
            setState(() {
              while(item.data()[i.toString()] != null){
                var puntoV = PuntoVendita.fromJson(item.data()[i.toString()]);
                widget.puntiVendita.add(puntoV);
                widget.puntiVenditaQuery.add(puntoV);
                i++;
              }
              
            });
            
          }
        );
    });
    
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    tiles.addAll(List<String>.generate(10, (index) => index.toString()));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Gestore Ricambi")),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(//Form
              
              children: [
                Text("Punto Vendita",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w300),), // TITOLO
                Container(padding: EdgeInsets.all(10),),
                Container(//
                  child: Column( //TEXTINPUT + RISULTATI
                    children: [
                     TextField(//TEXTINPUT
                      controller: widget.codiceController,
                      
                      onChanged: (value) {
                        //var queried 
                        setState(() {
                          widget.puntiVenditaQuery = widget.puntiVendita.where((element) => element.codDest!.toLowerCase().startsWith(value.toLowerCase()) || element.citta!.toLowerCase().startsWith(value.toLowerCase()) || value.isEmpty).toList();
                        });
                      },
                      style: TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                widget.codiceController.clear();
                                setState(() {
                                                                  widget.puntiVenditaQuery = widget.puntiVendita;

                                });
                              }, 
                              icon: Icon(Icons.cancel_outlined)
                            ),
                            border: OutlineInputBorder(),
                            hintText: 'Inserisci Punto Vendita',
                            hintStyle: TextStyle(fontSize: 14),
                            
                          ),
                      ),//FINE TEXTINPUT 

                      Container(padding: EdgeInsets.all(10),),

                      Container(//Risultati
                      height: MediaQuery.of(context).size.height*0.6,
                        child: ListView.builder(        
                          itemCount: widget.puntiVenditaQuery.length,
                          itemBuilder: (BuildContext context, int index){
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 0,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              selected: index == _selectedIndex,
                              selectedColor: Colors.blue.shade800,
                              selectedTileColor: Colors.lightBlue.shade100,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.puntiVenditaQuery[index].codDest.toString(),),
                                  Text(widget.puntiVenditaQuery[index].citta.toString(),)
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                            ),
                            );
                          },
                        ), 
                      )//FINE Risultati
                    ],
                  ),
                )// FINE TEXTINPUT + RISULTATI
              ],
            ),//FINE Form
            
            
          ],
        ),
    ),
    floatingActionButton: 
      Container(
        height: 50,
        width: 100,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
          onPressed: () async {
            if(_selectedIndex < 0){
              showDialog(
                context: context, 
                builder:  (context) {
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
                }
              );
            }else{
              context
                .read<DatiInstallazioneRicambiProvider>()
                .updatePuntoVendita(widget.puntiVenditaQuery[_selectedIndex].puntoVenditaFormattato());

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RicambioInstallatoPage(),
                )
              );
            }
          },
          child: Text(
            "Avanti",
            style: TextStyle(
              fontSize: 14
            )
          ),
        ),
    )
  );
  }
}