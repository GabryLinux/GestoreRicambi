import 'package:flutter/material.dart';

class DatePickingWidget extends StatefulWidget {
  DatePickingWidget({super.key});
  DateTime? selectedDate;
  bool isDateSelected = false;
  @override
  State<DatePickingWidget> createState() => _DatePickingWidgetState();

  DateTime? get getDate => selectedDate;
}

class _DatePickingWidgetState extends State<DatePickingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(
              "Seleziona Data Spedizione",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Row(
            children: [
              Flexible(child: OutlinedButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: widget.selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((pickedDate) {
                if (pickedDate != null) {
                  setState(() {
                    widget.selectedDate = pickedDate;
                  });
                }
              });
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 14, // padding interno del bottone
                vertical: 10,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20,),
                SizedBox(
                    width: 15), // distanza personalizzata tra icona e testo
                Text(
                  widget.selectedDate != null
                      ? "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}"
                      : "Nessuna Data",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )),
          Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          TextButton(
            onPressed: () {
              setState(() {
                widget.selectedDate = null;
              });
            },
            child: Text("Cancella"),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 15,
              ),
            ),
          )
            ],
          )
        ],
      ),
    );
  }
}
