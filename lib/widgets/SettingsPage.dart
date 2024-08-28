import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);
  var Nome = TextEditingController();
  String? errorMsg = null;
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

SnackBar snack = SnackBar(
  content: Text('Nome Utente Impostato'),
  action: SnackBarAction(label: "Chiudi", onPressed: (){})
);

class _SettingsPageState extends State<SettingsPage> {
   final _formKey = GlobalKey<FormState>();

   @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var variab = prefs.getString('User');
      if(variab != null){
        widget.Nome.text = variab;
      }
    });
    super.initState();
  }
   
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Gestore Ricambi")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: Column(
          children: [
            TextField(
              //TEXTINPUT
              key: _formKey,
              controller: widget.Nome,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorStyle: TextStyle(fontSize: 14),
              labelStyle: TextStyle(fontSize: 16),
              labelText: "Nome",
              hintStyle: TextStyle(fontSize: 18),
              errorText: widget.errorMsg,
              hintText: 'Inserisci Il Tuo Nome'),
            ), //FINE TEXTINPUT
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 100,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
          onPressed: () async {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            //_formKey.currentState!.validate();
            debugPrint(_formKey.currentState.toString());
            if(widget.Nome.text.length < 2){
              setState(() {
                widget.errorMsg = "Devi inserire un nome di almeno 2 lettere";
              });
              
            }else{
              setState(() {
                widget.errorMsg = null;
              });
              await prefs.setString("User", widget.Nome.text);
              ScaffoldMessenger.of(context).showSnackBar(snack);
            }
              
          },
          child: Text(
            "Salva",
            style: TextStyle(
              fontSize: 16
            )
          ),
        ),
      )
    );
  }
}