import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;

  bool isValidForm() {
    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }

  void sendLink() async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
  }
}
