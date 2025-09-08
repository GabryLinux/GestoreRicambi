
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/RicambioInstallatoPage.dart';
import 'package:flutter/material.dart';

class puntoVendita extends StatefulWidget {
  @override
  State<puntoVendita> createState() => _puntoVenditaState();
}

class _puntoVenditaState extends State<puntoVendita> {
  @override
  Widget build(BuildContext context) {
    return ListaPage(nextRoute: MaterialPageRoute(
      builder: (context) => RicambioInstallatoPage(),
    ));
  }
}
