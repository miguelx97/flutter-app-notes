import 'package:flutter/material.dart';
import 'package:taskii/global/colors.dart';
import 'package:taskii/global/scroll.dart';
import 'package:taskii/providers/categories.provider.dart';
import 'package:taskii/providers/notes.provider.dart';
import 'package:taskii/screens/add_note.screen.dart';
import 'package:taskii/screens/categories-management.screen.dart';
import 'package:taskii/screens/note_details.screen.dart';
import 'package:taskii/services/notification.services.dart';
import 'package:taskii/widgets/auth_check_redirection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
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
  initNotifications();
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

String Function(String url) rs = Utils.removeSlash;

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const AuthCheckRedirection();
      },
      routes: <RouteBase>[
        GoRoute(
          path: rs(AddNote.screenUrl),
          builder: (BuildContext context, GoRouterState state) {
            return const AddNote();
          },
        ),
        GoRoute(
          path: rs(CategoriesManagement.screenUrl),
          builder: (BuildContext context, GoRouterState state) {
            return const CategoriesManagement();
          },
        ),
        GoRoute(
          path: '${rs(NoteDetailsScreen.screenUrl)}/:nid',
          builder: (BuildContext context, GoRouterState state) {
            return NoteDetailsScreen(nid: state.params["nid"]!);
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Taskii',
      builder: EasyLoading.init(
          builder: (context, child) => MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!)),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Utils.customColor(const Color(0xff26CAD3)),
        scaffoldBackgroundColor: Utils.customColor(const Color(0xffF3F3F3)),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontSize: 20,
              fontFamily: 'Nunito',
              color: ThemeColors.dark,
              fontWeight: FontWeight.w300),
          titleSmall: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito',
              color: ThemeColors.medium,
              fontWeight: FontWeight.w300),
          labelSmall: TextStyle(
              fontSize: 18, fontFamily: 'Nunito', color: ThemeColors.dark),
          headlineMedium: TextStyle(
              fontSize: 23,
              fontFamily: 'Kalam',
              color: Colors.white,
              letterSpacing: 1),
          bodySmall: TextStyle(fontSize: 14, color: ThemeColors.medium),
          titleLarge: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      routerConfig: _router,
    );
  }
}
