import 'package:flutter/material.dart';

class DatePickingWidget extends StatefulWidget {
  const DatePickingWidget({super.key});

  @override
  State<DatePickingWidget> createState() => _DatePickingWidgetState();
}

class _DatePickingWidgetState extends State<DatePickingWidget> {
  DateTime? selectedDate;
  bool isDateSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          controlAffinity: ListTileControlAffinity.leading,
          value: isDateSelected,
          onChanged: (bool? value) {
            setState(() {
              isDateSelected = value!;
            });
          },
          title: Text("Data Prevista Consegna"),
        ),
        Visibility(
            visible: isDateSelected,
            child: OutlinedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
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
                  Text(selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Seleziona Data", style: TextStyle(fontSize: 16),),
                ],
              ),
            )
          )
      ],
    );
  }
}
