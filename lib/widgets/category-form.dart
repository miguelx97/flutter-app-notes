import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emojis;
import 'package:flutter/material.dart';
import 'package:taskii/global/ui.dart';
import 'package:taskii/ui/button_custom.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../global/colors.dart';
import '../providers/categories.provider.dart';

class CategoryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    if (categoriesProvider.selectedCategory == null) return Container();
    Category category = categoriesProvider.selectedCategory!;
    bool isNew = category.cid == null || category.cid!.isEmpty;

    submit() async {
      try {
        if (category.title.isEmpty || category.emoji.isEmpty) {
          throw Exception(
              AppLocalizations.of(context)!.errorCategoryFillFields);
        }
        category.title = category.title.trim();
        categoriesProvider.selectedCategory = null;
        if (isNew) {
          await categoriesProvider.insert(category);
        } else {
          await categoriesProvider.update(category);
        }
      } catch (e) {
        showError(e);
      }
    }

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
                Text(
                    isNew
                        ? AppLocalizations.of(context)!.categoryNew
                        : AppLocalizations.of(context)!.categoryUpdate,
                    style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold)),
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
                            context.pop();
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
                          ? AppLocalizations.of(context)!.categoryChooseIcon +
                              '  📘 📞 ✈ ...'
                          : AppLocalizations.of(context)!.categoryIcon +
                              ': ${category.emoji}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: category.title,
                  onFieldSubmitted: (value) => submit(),
                  onChanged: (value) => category.title = value,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.categoryName),
                  validator: ((value) {
                    return (value == null || value.isEmpty)
                        ? AppLocalizations.of(context)!.errorCategoryNoName
                        : null;
                  }),
                ),
                SizedBox(height: 15),
                ButtonCustom(
                  text: isNew
                      ? AppLocalizations.of(context)!.add
                      : AppLocalizations.of(context)!.update,
                  icon: Icons.check,
                  size: ButtonCustomSize.small,
                  onPressed: submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
