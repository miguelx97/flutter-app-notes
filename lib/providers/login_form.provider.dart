import 'package:flutter/material.dart';
import 'package:taskii/global/ui.dart';
import 'package:taskii/services/auth.service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String password2 = '';
  bool isLogin = true;
  bool _attempt = false;

  swipeLoginAmdRegister() {
    isLogin = !isLogin;
    notifyListeners();
  }

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  Future<void> loginOrRegister() async {
    EasyLoading.show(status: 'Entrando...', dismissOnTap: true);
    try {
      if (isLogin) {
        await _login();
      } else {
        await _register();
      }
    } on Exception catch (ex) {
      showError(ex);
    }
    EasyLoading.dismiss();
  }

  Future<void> _login() {
    return AuthService().signIn(email: email, password: password);
  }

  Future<void> _register() {
    return AuthService().signUp(email: email, password: password);
  }

  set attempt(bool attempt) {
    _attempt = attempt;
    notifyListeners();
  }

  bool get attempt {
    return _attempt;
  }
}
