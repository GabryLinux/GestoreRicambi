import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiInviaRicambiAMagazzinoRC.dart';
import 'package:appsme/DatiNotificaSpedizione.dart';
import 'package:appsme/DatiPuntoVendita.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/DatiUtente.dart';
import 'package:appsme/ResetDatiGenerali.dart';
import 'package:appsme/widgets/ErrorMSG/ErrorMSG.dart';
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
    ChangeNotifierProvider(
        create: (_) => DatiInviaRicambiAMagazzinoRCProvider()),
    ChangeNotifierProvider(create: (_) => DatiLuogoProvider()),
    ChangeNotifierProvider(create: (_) => DatiNotificaSpedizione()),
    // se ResetDatiGenerali ha bisogno di accedere agli altri provider
    // puoi passarglieli tramite context.read all'interno del suo costruttore
    ChangeNotifierProvider(create: (_) => ResetDatiGenerali()),
    ChangeNotifierProvider(create: (_) => DatiUtente()),
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
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? nomeUtente = "";
  int tipoUtente = 1000;

  ErrorMSG createDialog(BuildContext c) {
    return ErrorMSG(msg: "Devi fare il login per accedere a questa funzione. Clicca sulla rotellina!");
  }

  OutlinedButton createButton(String text, Widget w) {
    return OutlinedButton(
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var pin = prefs.getString('PIN');
          var user = prefs.getString('User');
          var type = prefs.getInt('TipoUtente');
          if (user == null ||
              user.isEmpty ||
              pin == null ||
              pin.isEmpty ||
              type == null) {
            showDialog(
                context: context, builder: (context) => createDialog(context));
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => w));
          }
        },
        child: Container(
          alignment: Alignment.center,
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
      setState(() {
        nomeUtente = prefs.getString('User');
        tipoUtente = prefs.getInt('TipoUtente') ?? 1000;
      });
      debugPrint("NOME UTENTE: $nomeUtente");
      debugPrint("TIPO UTENTE: $tipoUtente");
      context.read<DatiUtente>().addListener(() {
        debugPrint("UPDATE!");
        setState(() {
          nomeUtente = prefs.getString('User');
          tipoUtente = prefs.getInt('TipoUtente') ?? 1000;
          debugPrint("NOME UTENTE: $nomeUtente");
          debugPrint("TIPO UTENTE: $tipoUtente");
        });
      });
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
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 20),
                  child: Text(
                  "Menu Principale",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                ),

                // FINE: LOGO SUPERIORE //
                
                GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 15,
                      childAspectRatio: 3 / 1.5,
                    ),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      createButton("Installazione Ricambio", puntoVendita()),
                      createButton("Ricambio da Spostare", RicambioDaSpostare()),
                      createButton("Invia Ricambi a Magazzino RC", InviaRicambiMagazzinoRC()),
                      createButton("Ricezione Ricambi", RicezioneRicambiPage()),
                      if (tipoUtente < 1) ...[
                        createButton("Notifica Spedizione", NotificaSpedizione()),
                      ]
                    ]),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Created by Gabriele Favazzi, v2.0.0",
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
