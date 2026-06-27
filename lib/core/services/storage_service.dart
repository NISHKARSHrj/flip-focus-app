import 'dart:convert';

import 'package:flip/core/models/focus_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  // SharedPreferences ki key
  static const String sessionKey = "focus_sessions";

  // session save
  static Future<void> saveSession(FocusSession session) async {

    // SharedPreferences object
    final prefs = await SharedPreferences.getInstance();

    List<String> sessions =
        prefs.getStringList(sessionKey) ?? [];

    // Object ko JSON String 
    sessions.add(
      jsonEncode(
        session.toJson(),
      ),
    );

    await prefs.setStringList(
      sessionKey,
      sessions,
    );
  }

  // load session
  static Future<List<FocusSession>> loadSessions() async {

    final prefs = await SharedPreferences.getInstance();

    List<String> sessions =
        prefs.getStringList(sessionKey) ?? [];

    return sessions.map((item) {

      return FocusSession.fromJson(
        jsonDecode(item),
      );

    }).toList();
  }
}