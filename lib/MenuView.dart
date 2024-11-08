import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'RulesView.dart';

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
              width: 150,
              height: 150,
            ),
            Text(
              'MAFIA',
              style: GoogleFonts.creepster(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 186, 86, 36),
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){}, child: Text('Utwórz')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){}, child: Text('Dołącz')),
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