import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/main.dart';
import '../Services/SupabaseServices.dart';
import '../Widgets/CustomTextFormField.dart';
import 'package:mafia/constants.dart';

class JoinGameView extends StatefulWidget {
  const JoinGameView({Key? key}) : super(key: key);

  @override
  State<JoinGameView> createState() => _JoinGameViewState();
}

class _JoinGameViewState extends State<JoinGameView> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String playerName = '';
  SupabaseServices supabaseServices = SupabaseServices();
  String gameCode = '';
  int playerId = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    child:  Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dołacz do gry',
              style: GoogleFonts.creepster(
                textStyle: const TextStyle(
                  color: ORANGE,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    initialValue: null,
                    onChanged: (text) {
                      setState(() => playerName = text);
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Uzupełnij pole';
                      }
                      return null;
                    },
                    labelText: 'Nazwa gracza',
                    maxLength : 30,
                    maxLines: 1,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    initialValue: null,
                    labelText: "Kod gry",
                    maxLength: 8,
                    maxLines: 1,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (text) {
                      setState(() => gameCode = text);
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Uzupełnij pole';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:  () async {
                    if(_formKey.currentState!.validate()) {
                      int gameId = await supabaseServices.getGameIdByCode(gameCode);
                      if (gameId != -1) {
                        _showLobbyDialog(context);
                        playerId = await supabaseServices.createPlayer(playerName, gameId);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'Nie znaleziono gry dla podanego kodu.')),
                        );
                      }
                    }
                  },
                  child: const Text('Dołącz')
                ),
                SizedBox(width: 30),
                ElevatedButton(onPressed: () => goBack(context), child: const Text('Cofnij ')),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  void _showLobbyDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                'Lobby',
                style: const TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Oczekiwanie na rozpoczęcie gry przez gospodarza.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: ORANGE,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Cofnij'),
                  onPressed: () {
                    supabaseServices.deletePlayer(playerId);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

void goBack(BuildContext context) {
  Navigator.pop(context);
}

