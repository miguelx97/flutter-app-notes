import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/colors.dart';
import 'package:flutter_app_notas/global/constants.dart';
import 'package:flutter_app_notas/providers/login_form.provider.dart';
import 'package:flutter_app_notas/ui/button_custom.dart';
import 'package:flutter_app_notas/widgets/card_container.dart';
import 'package:provider/provider.dart';

import '../widgets/auth_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Login(),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          AuthBackground(
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: Constants.maxWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: 250),
                      CardContainer(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Text(
                                loginForm.isLogin
                                    ? 'Iniciar Sesión'
                                    : 'Nueva Cuenta',
                                style: Theme.of(context).textTheme.headline5),
                            const SizedBox(height: 30),
                            _LoginForm(loginForm: loginForm),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height - 60,
            left: 0,
            right: 0,
            child: TextButton(
                onPressed: () => loginForm.swipeLoginAmdRegister(),
                child: Text(
                  loginForm.isLogin
                      ? 'Crear una nueva cuenta'
                      : 'Ya tengo una cuenta',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w300),
                )),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final loginForm;
  const _LoginForm({super.key, this.loginForm});

  loginRegister(BuildContext context) {
    if (!loginForm.isValidForm()) return;
    FocusScope.of(context).unfocus();
    loginForm.loginOrRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginForm.email = value,
            decoration: const InputDecoration(
                hintText: 'micorreo@mail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined)),
            validator: ((value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '') ? null : 'Correo inválido';
            }),
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            onFieldSubmitted: (value) => loginRegister(context),
            onChanged: (value) => loginForm.password = value,
            decoration: const InputDecoration(
                hintText: '********',
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.password_outlined)),
            validator: ((value) {
              return (value ?? '').length < 6
                  ? 'La contraseña debe tener 6 caracteres'
                  : null;
            }),
          ),
          Visibility(
            visible: !loginForm.isLogin,
            child: TextFormField(
              autocorrect: false,
              obscureText: true,
              onFieldSubmitted: (value) => loginRegister(context),
              decoration: const InputDecoration(
                  hintText: '********',
                  labelText: 'Repetir contraseña',
                  prefixIcon: Icon(Icons.password_outlined)),
              validator: ((value) {
                return (value != loginForm.password)
                    ? 'Las contraseñas no coinciden'
                    : null;
              }),
            ),
          ),

          const SizedBox(height: 40),
          // Text(loginForm.isLoading.toString()),
          ButtonCustom(
            text: loginForm.isLogin ? 'Entrar' : 'Crear cuenta',
            icon: Icons.login_outlined,
            onPressed: () => loginRegister(context),
          ),
        ],
      ),
    );
  }
}
