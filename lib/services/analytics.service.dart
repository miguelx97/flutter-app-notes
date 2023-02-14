import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';

FirebaseAnalytics? _analytics = null;

Future<void> initAnalytics(User? user) async {
  // if (kIsWeb) return;
  if (user == null || _analytics != null) return;
  _analytics = FirebaseAnalytics.instance;
  await _analytics!.setUserId(id: user.uid);
  await _analytics!.setUserProperty(name: 'Email', value: user.email);
}

Future<void> logEvent(String tag, {Map<String, Object?>? metadata}) {
  print('$tag: ${metadata.toString()}');
  return _analytics!.logEvent(name: tag, parameters: metadata);
}
