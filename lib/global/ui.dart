import 'package:flutter_easyloading/flutter_easyloading.dart';

void showError(dynamic err) {
  String message = 'Se ha producido un error';
  if (err is String) {
    message = err;
  } else if (err.message != null) {
    message = err.message;
  }
  EasyLoading.showError(message);
}
