import 'package:flutter/material.dart';
import 'package:taskii/global/constants.dart';
import 'package:taskii/providers/login_form.provider.dart';
import 'package:taskii/ui/button_custom.dart';
import 'package:taskii/widgets/card_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/auth_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(AppLocalizations.of(context)!),
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
                                    ? AppLocalizations.of(context)!.loginSignin
                                    : AppLocalizations.of(context)!.loginSignup,
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
                      ? AppLocalizations.of(context)!.loginGoSignup
                      : AppLocalizations.of(context)!.loginGoSignin,
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
  final LoginFormProvider loginForm;
  const _LoginForm({super.key, required this.loginForm});

  loginRegister(BuildContext context) {
    loginForm.attempt = true;
    if (!loginForm.isValidForm()) return;
    FocusScope.of(context).unfocus();
    loginForm.loginOrRegister(AppLocalizations.of(context)!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginForm.formKey,
      autovalidateMode: !loginForm.attempt
          ? AutovalidateMode.disabled
          : AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginForm.email = value,
            decoration: InputDecoration(
                hintText: 'micorreo@mail.com',
                labelText: AppLocalizations.of(context)!.loginEmail,
                prefixIcon: Icon(Icons.email_outlined)),
            validator: ((value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : AppLocalizations.of(context)!.errorUserInvalidEmail;
            }),
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            onFieldSubmitted: (value) => loginRegister(context),
            onChanged: (value) => loginForm.password = value,
            decoration: InputDecoration(
                hintText: '********',
                labelText: AppLocalizations.of(context)!.loginPassword,
                prefixIcon: Icon(Icons.password_outlined)),
            validator: ((value) {
              return (value ?? '').length < 6
                  ? AppLocalizations.of(context)!.errorUserPasswordMinCharacters
                  : null;
            }),
          ),
          Visibility(
            visible: !loginForm.isLogin,
            child: TextFormField(
              autocorrect: false,
              obscureText: true,
              onFieldSubmitted: (value) => loginRegister(context),
              decoration: InputDecoration(
                  hintText: '********',
                  labelText: AppLocalizations.of(context)!.loginRepeatPassword,
                  prefixIcon: Icon(Icons.password_outlined)),
              validator: ((value) {
                return (value != loginForm.password)
                    ? AppLocalizations.of(context)!.errorUserPasswordsNoMatch
                    : null;
              }),
            ),
          ),

          const SizedBox(height: 40),
          // Text(loginForm.isLoading.toString()),
          ButtonCustom(
            text: loginForm.isLogin
                ? AppLocalizations.of(context)!.loginEnter
                : AppLocalizations.of(context)!.loginCreateAccount,
            icon: Icons.login_outlined,
            onPressed: () => loginRegister(context),
          ),
        ],
      ),
    );
  }
}
