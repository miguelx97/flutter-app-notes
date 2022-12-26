import 'package:flutter/material.dart';
import 'package:flutter_app_notas/services/auth.service.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String password2 = '';

  bool isLoading = false;
  bool isLogin = true;

  swipeLoginAmdRegister() {
    isLogin = !isLogin;
    notifyListeners();
  }

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  loginOrRegister() {
    if (isLogin) {
      return _login();
    } else {
      return _register();
    }
  }

  _login() {
    AuthService().signIn(email: email, password: password);
  }

  _register() {
    AuthService().signUp(email: email, password: password);
  }
}
