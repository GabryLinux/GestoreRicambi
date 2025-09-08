
import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiNotificaSpedizione.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/ResetDatiGenerali.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVenditaPage.dart';
import 'package:appsme/widgets/InviaRicambiMagazzinoRC/InviaRicambiMagazzinoRC.dart';
import 'package:appsme/widgets/NotificaSpedizione/NotificaSpedizione.dart';
import 'package:appsme/widgets/RicezioneRicambi/RicezioneRicambiPage.dart';
import 'package:appsme/widgets/SettingsPage.dart';
import 'package:appsme/widgets/SpostaRicambi/RicambioDaSpostare/RicambioDaSpostare.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var providers = [
  ChangeNotifierProvider(create: (_) => DatiInstallazioneRicambiProvider()),
  ChangeNotifierProvider(create: (_) => DatiSpostaRicambioProvider()),
  ChangeNotifierProvider(create: (_) => DatiInviaRicambiAMagazzinoRCProvider()),
  ChangeNotifierProvider(create: (_) => DatiLuogoProvider()),
  ChangeNotifierProvider(create: (_) => DatiNotificaSpedizione()),
  // se ResetDatiGenerali ha bisogno di accedere agli altri provider
  // puoi passarglieli tramite context.read all'interno del suo costruttore
  ChangeNotifierProvider(create: (_) => ResetDatiGenerali()),
];
  runApp(MultiProvider(
    providers: providers,
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SME APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Gestore Ricambi SME'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  String errorMsg = "";
  String? nomeUtente;
  int tipoUtente = 10000;
  bool flag = false;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AlertDialog createDialog (BuildContext c) {
    return new AlertDialog(
      content: Text("Devi inserire il nome utente. Clicca sulla rotellina!"),
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

  OutlinedButton createButton (String text, Widget w) {
    return OutlinedButton(
        onPressed: () async {
          final SharedPreferences prefs =
              await SharedPreferences.getInstance();
          var variab = prefs.getString('User');
          if (variab == null || variab.isEmpty) {
            showDialog(
                context: context, builder: (context) => createDialog(context));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => w));
          }
        },
        child: Container(
          child: Text(
            text,
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ));
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var variab = prefs.getString('User');
      widget.tipoUtente = int.tryParse(prefs.getString('TipoUtente') ?? '') ?? 1000;
      if (variab != null) {
        setState(() {
          widget.errorMsg =
              "Attenzione! Clicca sulla rotellina per inserire il nome utente";
          widget.flag = true;
        });
      } else {
        setState(() {
          widget.errorMsg =
              "Attenzione! Clicca sulla rotellina per inserire il nome utente";
          widget.flag = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                // INIZIO: LOGO SUPERIORE //
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/img/SME_LOGO.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                ),
                
                createButton("Installazione Ricambio", puntoVendita()),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                createButton("Ricambio da Spostare", RicambioDaSpostare()),
                Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                if(widget.tipoUtente < 2) ...[
                  createButton("Invia Ricambi a Magazzino RC", InviaRicambiMagazzinoRC()),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  createButton("Ricezione Ricambi", RicezioneRicambiPage()),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ],
                if (widget.tipoUtente < 1) ...[
                  createButton("Notifica Spedizione", NotificaSpedizione()),
                ]
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Created by Gabriele Favazzi, v1.1.4",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      "",
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => SettingsPage())));
        },
        child: Icon(
          Icons.settings,
          size: 30,
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
