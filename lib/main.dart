import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:mafia/Screens/MenuView.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const supabaseUrl = 'https://gpxewdudbpwmjufhkkyx.supabase.co';
// const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdweGV3ZHVkYnB3bWp1Zmhra3l4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI3MDY1NzcsImV4cCI6MjA0ODI4MjU3N30.OaUfRwyS0yu79itInY0LS2u4wpnFK2eUcHKn_8CLDgs";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      title: 'Mafia',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ORANGE,
            foregroundColor: Colors.black,
            shadowColor: Colors.yellow,
            elevation: 10,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (states) {
                if (states.contains(WidgetState.disabled)) {
                  return ORANGE.brighten(0.25);
                }
                return ORANGE;
              },
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return ORANGE; // Kolor tła dla disabled
                }
                return Colors.black;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black;
                }
                return Colors.white;
              },
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuView(),
    );
  }
}


