import 'package:flutter/material.dart';

class DatePickingWidget extends StatefulWidget {
  DatePickingWidget({super.key});
  DateTime? selectedDate;
  bool isDateSelected = false;
  @override
  State<DatePickingWidget> createState() => _DatePickingWidgetState();

  DateTime? get getDate => isDateSelected ? selectedDate : null;
}

class _DatePickingWidgetState extends State<DatePickingWidget> {
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          controlAffinity: ListTileControlAffinity.leading,
          value: widget.isDateSelected,
          onChanged: (bool? value) {
            setState(() {
              widget.isDateSelected = value!;
            });
          },
          title: Text("Data Prevista Consegna"),
        ),
        Visibility(
            visible: widget.isDateSelected,
            child: OutlinedButton(
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
                  vertical: 15,
                ),
              ),
              child: Row(
                
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(
                      width: 23), // distanza personalizzata tra icona e testo
                  Text(widget.selectedDate != null
                      ? "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}"
                      : "Seleziona Data", style: TextStyle(fontSize: 16),),
                ],
              ),
            )
          )
      ],
    );
  }
}
