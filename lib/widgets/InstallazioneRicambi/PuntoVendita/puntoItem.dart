import 'package:flutter/material.dart';

class puntoItem extends StatefulWidget {
  puntoItem({Key? key}) : super(key: key);

  @override
  State<puntoItem> createState() => _puntoItemState();
}

class _puntoItemState extends State<puntoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: OutlinedButton(
        style: ButtonStyle(
        ),
        onPressed: () {},
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Text(
            "Prova",
            style: TextStyle(fontSize: 16),
          ),
        )
    ),
    );
  }
}