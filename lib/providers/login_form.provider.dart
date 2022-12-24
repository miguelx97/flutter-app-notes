import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  bool isLoading = false;

  bool isValidForm() => formKey.currentState?.validate() ?? false;

  void sendLink() async {
    isLoading = true;
    notifyListeners();
    // // await Future.delayed(Duration(seconds: 1));

    var acs = ActionCodeSettings(
        // URL you want to redirect back to. The domain (www.example.com) for this
        // URL must be whitelisted in the Firebase Console.
        url: 'https://www.example.com/finishSignUp?cartId=1234',
        // This must be true
        handleCodeInApp: true,
        // iOSBundleId: 'com.example.ios',
        androidPackageName: 'miguel.martin.taskii',
        // installIfNotAvailable
        androidInstallApp: true,
        // minimumVersion
        androidMinimumVersion: '12');

    FirebaseAuth.instance
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError(
            (onError) => print('Error sending email verification $onError'))
        .then((value) => print('Successfully sent email verification'));

    isLoading = false;
    notifyListeners();
  }
}
