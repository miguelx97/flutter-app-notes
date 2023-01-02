import 'package:flutter/material.dart';
import 'package:flutter_app_notas/global/scroll.dart';
import 'package:flutter_app_notas/providers/categories.provider.dart';
import 'package:flutter_app_notas/providers/notes.provider.dart';
import 'package:flutter_app_notas/screens/add_note.screen.dart';
import 'package:flutter_app_notas/screens/categories-management.screen.dart';
import 'package:flutter_app_notas/screens/note_details.screen.dart';
import 'package:flutter_app_notas/widgets/auth_check_redirection.dart';
import 'global/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeDateFormatting();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoriesProvider(), lazy: true),
        ChangeNotifierProvider(create: (_) => NotesProvider(), lazy: true),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Notas',
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Utils.customColor(const Color(0xff26CAD3)),
          scaffoldBackgroundColor: Utils.customColor(const Color(0xffF3F3F3))),
      initialRoute: '',
      routes: {
        '': (_) => const AuthCheckRedirection(),
        'add-note': (_) => const AddNote(),
        'categories': (_) => const CategoriesManagement(),
        'note-details': (_) => const NoteDetailsScreen(),
      },
    );
  }
}
