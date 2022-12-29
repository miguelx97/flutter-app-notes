import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emojis;
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';

import '../global/colors.dart';
import '../providers/categories.provider.dart';

class CategoryForm extends StatelessWidget {
  bool isShowSticker = true;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    if (categoriesProvider.selectedCategory == null) return Container();
    Category category = categoriesProvider.selectedCategory!;
    bool isNew = category.cid == null || category.cid!.isEmpty;
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
                Text(isNew ? 'Nueva Categoría' : 'Actualizar Categoría',
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
                        child: emojis.EmojiPicker(
                          onEmojiSelected: (_, emojis.Emoji emoji) {
                            category.emoji = emoji.emoji;
                            categoriesProvider.selectedCategory = category;
                            Navigator.pop(context);
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
                      (category.emoji.isEmpty)
                          ? 'Elige icono  📘 📞 ✈ ...'
                          : 'Icono: ${category.emoji}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  initialValue: category.title,
                  onChanged: (value) => category.title = value,
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
                  child: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isNew ? 'Añadir' : 'Actualizar',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  onPressed: () {
                    if (category.title.isEmpty || category.emoji.isEmpty)
                      return;
                    if (isNew) {
                      // category.id = const Uuid().v1();
                      categoriesProvider.insert(category);
                    } else {
                      categoriesProvider.update(category);
                    }
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
