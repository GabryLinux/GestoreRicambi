
import 'package:appsme/ResetDatiGenerali.dart';
import 'package:appsme/widgets/SpostaRicambi/CollegaRicambio/Collega.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EmailSendPage extends StatelessWidget {
  final List<Collega> colleghi = [];
  final Future<void> Function(BuildContext) sendFunction;
  EmailSendPage({super.key, required this.sendFunction});

  @override
  Widget build(BuildContext context) {
    sendFunction(context).then((value) {
      context.read<ResetDatiGenerali>().resetAll(context);
      return const Scaffold();
    });
    return const Scaffold();
  }

  
}

