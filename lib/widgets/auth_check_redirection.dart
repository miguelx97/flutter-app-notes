import 'package:flutter/widgets.dart';

import '../screens/home.screen.dart';
import '../screens/login.screen.dart';
import '../services/auth.service.dart';

class AuthCheckRedirection extends StatelessWidget {
  const AuthCheckRedirection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
