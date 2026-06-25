import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:flutter/services.dart';
// import 'screens/focus_screen.dart';
// import 'core/constants/colors.dart';
// import 'core/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // status bar transparent rahegi
      statusBarColor: Colors.transparent,

      // Android status bar icons white honge
      statusBarIconBrightness: Brightness.light,

      // iPhone ke liye
      statusBarBrightness: Brightness.dark,
    ),
  );
  runApp(const FlipApp());
}

class FlipApp extends StatelessWidget {
  const FlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
