import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/DatiSpostaRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVenditaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/RicambioInstallatoPage.dart';
import 'package:appsme/widgets/SettingsPage.dart';
import 'package:appsme/widgets/SpostaRicambi/RicambioDaSpostare/RicambioDaSpostare.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DatiInstallazioneRicambiProvider()),
      ChangeNotifierProvider(create: (_) => DatiSpostaRicambioProvider())
    ],
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
  bool flag = false;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var variab = prefs.getString('User');
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
                Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 200,
              decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/SME_LOGO.png'),
            fit: BoxFit.cover
          ),
        ),),
            Container(
              margin: EdgeInsets.all(10),
            ),
            OutlinedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var variab = prefs.getString('User');
                  if (variab == null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content:
                                Text("Devi inserire il nome utente. Clicca sulla rotellina!"),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => puntoVendita())));
                  }
                },
                child: Container(
                  child: Text(
                    "Installazione Ricambio",
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                )),
            Container(
              margin: EdgeInsets.all(10),
            ),
            OutlinedButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                var variab = prefs.getString('User');
                if (variab == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              Text("Devi inserire il nome utente. Clicca sulla rotellina!"),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => RicambioDaSpostare())));
                }
              },
              child: Container(
                child: Text(
                  "     Sposta Ricambio     ",
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              ),
            ),
            
              ],
              
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Created by Gabriele Favazzi, v1.1.3",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20
                    ),
                  ),
                ],
              )
            )
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
