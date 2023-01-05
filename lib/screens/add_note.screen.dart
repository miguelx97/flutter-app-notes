import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/global/utils.dart';
import 'package:flutter_app_notas/models/reminder_time.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:flutter_app_notas/widgets/category_picker_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/category.dart';
import '../models/note.dart';
import '../ui/button_custom.dart';

class AddNote extends StatefulWidget {
  static const screenUrl = '/add-note';
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
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
      DateTime? selectedDate = note.date;
      TimeOfDay? selectedTime =
          selectedDate != null ? TimeOfDay.fromDateTime(selectedDate) : null;

      final DateTime? datePicker = await showDatePicker(
          context: context,
          confirmText: 'Aceptar',
          cancelText: 'Cancelar',
          helpText: 'Selecciona fecha',
          initialDate: selectedDate ?? now,
          firstDate: DateTime(2020),
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
        note.hasTime = false;
        setState(() {});
        return;
      }

      note.date = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      note.hasTime = true;

      setState(() {});
    }

    resetDateTime({reload = true}) {
      note.date = null;
      note.hasTime = false;
      if (reload) setState(() {});
    }

    updateReminderTime(bool isChecked, int minutesBefore) {
      if (isChecked == true) {
        note.reminderTime = minutesBefore;
      } else {
        note.reminderTime = null;
      }
      setState(() {});
    }

    saveAndUpdate() async {
      FocusScope.of(context).unfocus();
      if (isNew) {
        await notesProvider.insert(note);
      } else {
        await notesProvider.update(note);
      }
      notesProvider.selectedNote = Note();
      notesProvider.formKey.currentState?.reset();
      resetDateTime(reload: false);

      setState(() {
        context.pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'Añadir nota',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: Constants.maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  CategoriesPickerSlider(
                    idSelectedCategory: note.categoryId,
                    onCategorySelected: (Category category) {
                      note.categoryId = category.cid;
                      setState(() {});
                    },
                  ),
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
                                  side:
                                      BorderSide(color: ThemeColors.lightGrey),
                                ),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 18))),
                          child: Text(
                            note.date == null
                                ? 'Selecciona fecha y hora'
                                : Utils.dateTimeFormat(note.date!,
                                    hasTime: note.hasTime, short: note.hasTime),
                            style: const TextStyle(
                                fontSize: 18, color: ThemeColors.dark),
                          ),
                        ),
                        SizedBox(width: 20),
                        Visibility(
                          visible: note.date != null,
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
                  Visibility(
                    visible: note.hasTime,
                    child: Column(
                      children: [
                        SectionTitle('Notificación'),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: ThemeColors.lightGrey)),
                            child: Column(
                              children: [
                                checkBoxReminderTime(
                                    note,
                                    ReminderTime.quarterHour,
                                    updateReminderTime),
                                checkBoxReminderTime(note, ReminderTime.oneHour,
                                    updateReminderTime),
                                checkBoxReminderTime(note, ReminderTime.oneDay,
                                    updateReminderTime),
                              ],
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }

  CheckboxListTile checkBoxReminderTime(Note note, int reminderTime,
      Function(bool isChecked, int minutesBefore) updateReminderTime) {
    return CheckboxListTile(
      value: note.reminderTime == reminderTime,
      onChanged: ((isChecked) => updateReminderTime(isChecked!, reminderTime)),
      title: Text(ReminderTime.getLabel(reminderTime)),
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
