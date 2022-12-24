import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/scroll.dart';
import 'package:flutter_app_notas/screens/add_note.screen.dart';
import 'package:flutter_app_notas/screens/categories-management.screen.dart';
import 'package:flutter_app_notas/screens/home.screen.dart';
import 'package:flutter_app_notas/screens/login.screen.dart';
import 'global/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Utils.customColor(const Color(0xff26CAD3)),
          scaffoldBackgroundColor: Utils.customColor(const Color(0xffF3F3F3))),
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'add-note': (_) => AddNote(),
        'categories': (_) => CategoriesManagement()
      },
    );
  }
}
