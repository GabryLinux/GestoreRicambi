import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  var Nome = TextEditingController();
  var PIN = TextEditingController();
  var TipoUtente = TextEditingController();
  String? errorMsg = null;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

SnackBar snackSuccess = SnackBar(
    content: Text('Login effettuato con successo'),
    action: SnackBarAction(label: "Chiudi", onPressed: () {}));

SnackBar snackError = SnackBar(
    content: Text('Login fallito, riprova'),
    action: SnackBarAction(label: "Chiudi", onPressed: () {}));

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var variab = prefs.getString('User');
      var TipoUtente = prefs.getString('TipoUtente');
      widget.Nome.text = variab ?? "";
      if (TipoUtente != null) {
        widget.TipoUtente.text = getUserType(TipoUtente);
      }
    });
    super.initState();
  }

  String getUserType(String type) {
    switch (type) {
      case '0':
        return 'Magazzino';
      case '1':
        return 'Utente';
      case '2':
        return 'CapoArea';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Gestore Ricambi")),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Dati Utente",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              TextField(
                //TEXTINPUT
                controller: widget.Nome,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 14),
                    labelStyle: TextStyle(fontSize: 16),
                    labelText: "Utente APP",
                    hintStyle: TextStyle(fontSize: 18),
                    hintText: 'Inserisci Il Tuo Nome'),
              ), //FINE TEXTINPUT
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              TextField(
                //TEXTINPUT
                controller: widget.TipoUtente,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 14),
                    labelStyle: TextStyle(fontSize: 16),
                    labelText: "Tipo Utente",
                    hintStyle: TextStyle(fontSize: 18),
                    hintText: 'Inserisci Il Tuo Nome'),
              ), //FINE TEXTINPUT
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Divider(
                thickness: 1,
                color: Colors.black12,
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Area Login",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              TextField(
                //TEXTINPUT
                controller: widget.PIN,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(fontSize: 14),
                    labelStyle: TextStyle(fontSize: 16),
                    labelText: "PIN",
                    hintStyle: TextStyle(fontSize: 18),
                    errorText: widget.errorMsg,
                    hintText: 'Inserisci Il Tuo PIN'),
              ), //FINE TEXTINPUT
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
              var Nome = "";
              var TipoUtente = "";
              var PIN = "";
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              //_formKey.currentState!.validate();
              debugPrint(_formKey.currentState.toString());
              if (widget.PIN.text.length != 4) {
                setState(() {
                  widget.errorMsg = "Devi inserire un PIN di 4 cifre";
                });
              } else {
                setState(() {
                  widget.errorMsg = null;
                });
                bool userFound = false;
                await FirebaseFirestore.instance
                    .collection('UTENTI')
                    .get()
                    .then((value) {
                  value.docs.forEach((element) {
                    if (element['PIN'] == widget.PIN.text) {
                      debugPrint(element['TipoUtente'].toString());
                      Nome = element['Nome'] + " " + element['Cognome'];
                      TipoUtente = element['TipoUtente'].toString();
                      PIN = element['PIN'];
                      userFound = true;
                    }
                  });
                });
                widget.Nome.text = Nome;
                widget.TipoUtente.text = getUserType(TipoUtente);
                widget.PIN.text = PIN;

                await prefs.setString("User", widget.Nome.text);
                await prefs.setString("TipoUtente", TipoUtente);
                await prefs.setString("PIN", widget.PIN.text);

                if(userFound){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
                }

                ScaffoldMessenger.of(context).showSnackBar(userFound ? snackSuccess : snackError);
              }
            },
            child: Text("Salva", style: TextStyle(fontSize: 16)),
          ),
        ));
  }
}
