import 'package:flutter/widgets.dart';
import 'package:flutter_app_notas/services/auth.service.dart';

class CategoriesProvider extends ChangeNotifier {
  getUserId() {
    return AuthService().currentUser;
  }
}
