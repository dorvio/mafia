import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Screens/MenuView.dart';
import 'package:mafia/constants.dart';

class EndGameView extends StatelessWidget {
  final int endGameResult;


  const EndGameView({
    Key? key,
    required this.endGameResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'KONIEC GRY',
                        style: GoogleFonts.creepster(
                          textStyle: const TextStyle(
                            color: ORANGE,
                            fontWeight: FontWeight.bold,
                            fontSize: 70,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      endGameResult == 2 ? "Mafia wygrała." : "Miasto wygrało.",
                      style: const TextStyle(
                        color: ORANGE,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () => goToMenu(context),
                child: const Text('MENU'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void goToMenu(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MenuView()),
  );
}