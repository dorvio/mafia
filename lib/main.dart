import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:mafia/Screens/MenuView.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const supabaseUrl = 'https://gpxewdudbpwmjufhkkyx.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuView(),
    );
  }
}


