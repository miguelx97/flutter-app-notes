import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/reminder_time.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:flutter_app_notas/widgets/category_picker_slider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/note.dart';
import '../ui/button_custom.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    Note note = notesProvider.selectedNote!;
    bool isNew = note.nid == null || note.nid!.isEmpty;

    swipeFavourite() {
      note.isFavourite = !note.isFavourite;
      setState(() {});
    }

    selectDateTime() async {
      final now = DateTime.now();
      final DateTime? datePicker = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)));

      if (datePicker == null) return;
      selectedDate = datePicker;

      selectedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
        helpText: 'Escoge la hora',
        confirmText: 'Aceptar',
        cancelText: 'Solo Fecha',
      );

      if (selectedTime == null) {
        note.date = selectedDate;
        setState(() {});
        return;
      }

      setState(() {});
    }

    resetDateTime() {
      selectedDate = null;
      selectedTime = null;
      setState(() {});
    }

    updateReminderTime(bool isChecked, int minutesBefore) {
      if (isChecked == true) {
        note.reminderTime = minutesBefore;
      } else {
        note.reminderTime = null;
      }
      setState(() {});
    }

    saveAndUpdate() {
      note.date = selectedDate;
      if (selectedTime != null) {
        note.date = DateTime(
          note.date!.year,
          note.date!.month,
          note.date!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );
      }
      notesProvider.insert(note);

      notesProvider.selectedNote = Note();
      notesProvider.formKey.currentState?.reset();

      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Añadir nota',
        style: TextStyle(
          color: Colors.white,
        ),
      )),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: notesProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: note.title,
                  onChanged: (value) => note.title = value,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    suffixIcon: IconButton(
                      icon: Icon(
                          note.isFavourite ? Icons.star : Icons.star_outline,
                          color: Colors.amber),
                      onPressed: swipeFavourite,
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  maxLength: 100,
                  validator: ((value) {
                    return (value == null || value.isEmpty)
                        ? 'Introduce un título'
                        : null;
                  }),
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  maxLength: 400,
                  initialValue: note.description,
                  onChanged: (value) => note.description = value,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
                SectionTitle('Categorías'),
                CategoriesPickerSlider(),
                SectionTitle('Fecha y hora'),
                Padding(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: selectDateTime,
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: ThemeColors.lightGrey),
                              ),
                            ),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 18))),
                        child: Text(
                          selectedDate == null
                              ? 'Selecciona fecha y hora'
                              : Utils.dateTimeFormat(
                                  selectedDate!, selectedTime),
                          style: const TextStyle(
                              fontSize: 18, color: ThemeColors.dark),
                        ),
                      ),
                      SizedBox(width: 20),
                      Visibility(
                        visible: selectedDate != null,
                        child: IconButton(
                          onPressed: resetDateTime,
                          icon: Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: Icon(Icons.refresh_outlined),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SectionTitle('Notificación'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ThemeColors.lightGrey)),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: note.reminderTime == ReminderTime.oneDay,
                          onChanged: ((isChecked) => updateReminderTime(
                              isChecked!, ReminderTime.oneDay)),
                          title: const Text('Un día antes'),
                        ),
                        CheckboxListTile(
                          value: note.reminderTime == ReminderTime.oneHour,
                          onChanged: ((isChecked) => updateReminderTime(
                              isChecked!, ReminderTime.oneHour)),
                          title: const Text('Una hora antes'),
                        ),
                        CheckboxListTile(
                          value: note.reminderTime == ReminderTime.quarterHour,
                          onChanged: ((isChecked) => updateReminderTime(
                              isChecked!, ReminderTime.quarterHour)),
                          title: const Text('15 minutos antes'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ButtonCustom(
                    text: isNew ? 'Añadir' : 'Actualizar',
                    icon: Icons.check,
                    onPressed: saveAndUpdate,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, color: ThemeColors.medium),
      ),
    );
  }
}
