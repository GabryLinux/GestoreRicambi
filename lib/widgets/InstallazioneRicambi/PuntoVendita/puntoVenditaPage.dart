import 'dart:convert';

import 'package:appsme/DatiInstallazioneRicambio.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaPage.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/listaRisultati.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoItem.dart';
import 'package:appsme/widgets/InstallazioneRicambi/PuntoVendita/puntoVendita.dart';
import 'package:appsme/widgets/InstallazioneRicambi/RicambioInstallato/RicambioInstallatoPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
