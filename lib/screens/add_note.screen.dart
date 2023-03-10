import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/global/utils.dart';
import 'package:taskii/models/reminder_time.dart';
import 'package:taskii/providers/notes.provider.dart';
import 'package:taskii/widgets/category_picker_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:math';

import '../models/category.dart';
import '../models/note.dart';

class AddNote extends StatefulWidget {
  static const screenUrl = '/add-note';
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController addSubtaskController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    addSubtaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    Note note = notesProvider.selectedNote!;

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
          // confirmText: 'Aceptar',
          // cancelText: 'Cancelar',
          // helpText: 'Selecciona fecha',
          initialDate: selectedDate ?? now,
          firstDate: DateTime(2020),
          lastDate: now.add(const Duration(days: 365)));

      if (datePicker == null) return;
      selectedDate = datePicker;

      selectedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
        // helpText: 'Escoge la hora',
        cancelText: AppLocalizations.of(context)!.noteOnlyDate,
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

    addSubtask() {
      if (addSubtaskController.text.isEmpty) return;
      note.subtasks.insert(0, SubTask(title: addSubtaskController.text));
      addSubtaskController.clear();

      setState(() {});
    }

    deleteSubtask(SubTask subtask) {
      note.subtasks.remove(subtask);
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
        note.reminderTime = 0;
      }
      setState(() {});
    }

    saveAndUpdate() async {
      FocusScope.of(context).unfocus();
      await notesProvider.saveAndUpdate(note);
      notesProvider.selectedNote = Note();
      notesProvider.formKey.currentState?.reset();
      resetDateTime(reload: false);

      setState(() {
        context.pop();
      });
    }

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(
            AppLocalizations.of(context)!.noteAdd,
            style: textTheme.headlineMedium,
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: Constants.maxWidth,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: notesProvider.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: note.title,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) => note.title = value,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.noteTitle,
                      labelStyle: textTheme.titleSmall,
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
                          ? AppLocalizations.of(context)!.noteInsertTitle
                          : null;
                    }),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    maxLength: 400,
                    initialValue: note.description,
                    onChanged: (value) => note.description = value,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.noteDescription,
                      labelStyle: textTheme.titleSmall,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: addSubtaskController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.noteAddSubtask,
                      labelStyle: textTheme.titleSmall,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle_outline_outlined,
                            color: ThemeColors.primary),
                        onPressed: addSubtask,
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(left: 10),
                    shrinkWrap: true,
                    itemCount: note.subtasks.length,
                    itemBuilder: (_, index) => SubtaskItem(
                      subtask: note.subtasks[index]!,
                      onDelete: deleteSubtask,
                    ),
                  ),
                  SizedBox(height: 20),
                  SectionTitle(AppLocalizations.of(context)!.noteCategories),
                  CategoriesPickerSlider(
                    idSelectedCategory: note.categoryId,
                    emptyCategoriesMessage: true,
                    onCategorySelected: (Category? category) {
                      note.categoryId = category?.cid;
                      setState(() {});
                    },
                  ),
                  SectionTitle(AppLocalizations.of(context)!.noteDateTime),
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
                                ? AppLocalizations.of(context)!
                                    .noteSelectDateTime
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                            AppLocalizations.of(context)!.noteNotification),
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
                                    ReminderTime.justOnTime,
                                    updateReminderTime),
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
                  SizedBox(height: 50),
                  // Center(
                  //   child: ButtonCustom(
                  //     text: isNew ? 'A??adir' : 'Actualizar',
                  //     icon: Icons.check,
                  //     onPressed: saveAndUpdate,
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveAndUpdate,
        heroTag: 'main-floating-button',
        child: const Icon(
          Icons.check,
          size: 35,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 20),
      child: Text(
        title,
        style: textTheme.titleSmall,
      ),
    );
  }
}

class SubtaskItem extends StatelessWidget {
  final SubTask subtask;
  final Function onDelete;
  const SubtaskItem({super.key, required this.subtask, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        //                    <-- BoxDecoration
        border: Border(bottom: BorderSide(color: ThemeColors.lightGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subtask.title),
          IconButton(
              onPressed: () => onDelete(subtask),
              icon: Icon(
                Icons.remove_circle_outline_outlined,
                color: ThemeColors.danger,
              ))
        ],
      ),
    );
  }
}
