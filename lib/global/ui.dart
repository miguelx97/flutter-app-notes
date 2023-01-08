import 'package:flutter_easyloading/flutter_easyloading.dart';

void showError(dynamic err,
    {String defaultMessage = 'Se ha producido un error'}) {
  String message = defaultMessage;
  try {
    if (err.code != null) message = err.code;
  } on NoSuchMethodError {
    if (err is String) {
      message = err;
    } else if (err.message != null) {
      message = err.message;
    }
  }
  EasyLoading.showError(message);
}
