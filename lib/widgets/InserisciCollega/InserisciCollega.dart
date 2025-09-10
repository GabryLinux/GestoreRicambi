import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InserisciCollega extends StatefulWidget {
  InserisciCollega(
      {super.key, required this.text, this.defaultValueSet = false});
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      FirebaseFirestore.instance.collection('UTENTI').get().then((value) {
        setState(() {
          colleghi.add(Collega.NULL);
          for (var element in value.docs) {
            var collega = Collega.fromJson(element.data());
            colleghi.add(collega);
          }
          
          var variab = prefs.getString('User');
          colleghi.removeWhere((element) => element.nome! + " " + element.cognome! == variab);
        });
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
