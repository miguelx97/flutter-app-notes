import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as Emojis;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';

import '../global/colors.dart';
import '../providers/categories.provider.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final inputNameController = TextEditingController();
  bool isShowSticker = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    if (categoriesProvider.selectedCategory == null) return Container();
    Category category = categoriesProvider.selectedCategory!;
    return Padding(
      padding: EdgeInsets.only(right: 30, left: 30, bottom: 5, top: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ThemeColors.lightGrey)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Form(
            child: Column(
              children: [
                const Text('Nueva Categoría',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: null,
                      builder: (context) => SizedBox(
                        height: 300,
                        child: Emojis.EmojiPicker(
                          onEmojiSelected: (_, Emojis.Emoji emoji) {
                            print(emoji);
                            category.emoji = emoji.emoji;
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  padding: EdgeInsets.all(0),
                  minWidth: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (category.emoji == null)
                          ? 'Elige icono  📘 📞 ✈ ...'
                          : 'Icono: ${category.emoji}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  controller: inputNameController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de la categoría'),
                  validator: ((value) {
                    return (value == null || value.isEmpty)
                        ? 'Introduce un nombre'
                        : null;
                  }),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: ThemeColors.pimary,
                  child: Text(
                    'Añadir ✔',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    category.id = const Uuid().v1();
                    category.title = inputNameController.text;
                    categoriesProvider.insert(category);
                    inputNameController.clear();
                    categoriesProvider.selectedCategory = null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
