import 'package:appsme/widgets/InstallazioneRicambi/ImageRicambio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoWidget extends StatefulWidget {
  PhotoWidget({super.key, required this.title, required this.text, required this.FotoPath});
  final ImagePicker _picker = ImagePicker();
  int counter = 0;
  List<String> FotoPath;
  String title;
  String text;

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            onPressed: () async {
              widget.counter++;
              final XFile? photo =
                  await widget._picker.pickImage(source: ImageSource.camera);
              String path = photo!.path.replaceFirst(
                  photo.name, widget.text + " ${widget.counter}.png");
              await photo.saveTo(path);
              setState(() {
                if (photo.path != null) {
                  widget.FotoPath.add(path);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 14),
              ),
            )),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade300)),
          child: ListView.builder(
              itemCount: widget.FotoPath.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                debugPrint(i.toString());
                return ImageRicambioItem(
                    key: Key(i.toString()),
                    Nome: i.toString(),
                    DeleteFunc: () {
                      setState(() {
                        widget.FotoPath.removeAt(i);
                      });
                    });
                //return Container();
              }),
        ),
        
      ],
    );
  }
}
