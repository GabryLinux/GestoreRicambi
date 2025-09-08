import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InserisciCollega extends StatefulWidget {
  InserisciCollega({super.key, required this.text, this.defaultValueSet = false});
  final String text;
  @override
  State<InserisciCollega> createState() => _InserisciCollegaState();
  Collega? selectedCollega;
  bool defaultValueSet;

  Collega? get getCollega => selectedCollega;
}

class _InserisciCollegaState extends State<InserisciCollega> {
  final List<Collega> colleghi = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseFirestore.instance.collection('0').get().then((value) {
        var item = value.docs[0];
        List<Map<String, dynamic>> itemJson = [];
        colleghi.add(Collega.NULL);
        int i = 0;
        while (item.data()[i.toString()] != null) {
          if (item.data()[i.toString()]['NOME'] != "") {
            //AGGIUNGO SOLO SE I CAMPI SONO PIENI
            colleghi.add(Collega.fromJson(item.data()[i.toString()]));
          }
          i++;
        }
        debugPrint(colleghi.length.toString());
        setState(() {});
      });
    });
    if (widget.defaultValueSet) {
      widget.selectedCollega = Collega.NULL;
    }
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Collega>(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        isExpanded: true,
        value: widget.selectedCollega,
        onChanged: (Collega? value) {
          setState(() {
            widget.selectedCollega = value;
          });
        },
        hint: Text("Consegna a"),
        items: colleghi.map<DropdownMenuItem<Collega>>((Collega value) {
          return DropdownMenuItem<Collega>(
            value: value,
            child: Text(value.nome! + " " + value.cognome!),
          );
        }).toList());
  }
}
