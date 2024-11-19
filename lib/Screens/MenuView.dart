import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Screens/JoinGameView.dart';
import 'package:mafia/Screens/CreateGameView.dart';
import 'package:mafia/Screens/RulesView.dart';
import 'package:mafia/constants.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/images/mafia_guy.png',
              width: 200,
              height: 200,
            ),
            Text(
              'MAFIA',
              style: GoogleFonts.creepster(
                textStyle: const TextStyle(
                  color: ORANGE,
                  fontWeight: FontWeight.bold,
                  fontSize: 70,
                  letterSpacing: 15,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => createGame(context), child: Text('Utwórz')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => joinGame(context), child: Text('Dołącz')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => goToRulesView(context),
                child: Text('Zasady')),
          ],
        )
      )
    );
  }
}

void goToRulesView(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RulesView()),
  );
}

void joinGame(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JoinGameView()),
  );
}

void createGame(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateGameView()),
  );
}