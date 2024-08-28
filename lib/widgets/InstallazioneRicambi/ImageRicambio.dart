import 'package:flutter/material.dart';

class ImageRicambioItem extends StatefulWidget {
  ImageRicambioItem({Key? key, required this.Nome, required this.DeleteFunc}) : super(key: key);
  VoidCallback DeleteFunc = () {
    debugPrint("not caricato");
  };
  String Nome = "";
  @override
  State<ImageRicambioItem> createState() => _ImageRicambioItemState();
}

class _ImageRicambioItemState extends State<ImageRicambioItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.image),
            Text(widget.Nome),
            IconButton(onPressed: widget.DeleteFunc, icon: Icon(Icons.cancel_outlined))
          ],
        ),
        
      ),
    );
  }
}