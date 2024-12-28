import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

class PlayerListWidget extends StatefulWidget {
  final PlayerList players;
  final int playerRoleId;

  const PlayerListWidget({
    Key? key,
    required this.players,
    required this.playerRoleId,
  }) : super(key: key);

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {

  Map<int, String> textToRole = {
    1: "Wybierz kogo chcesz obronić:",
    2: "Zapytaj czy jest w mafii:",
    3: "Wybierz kogo zabimbrować:",
    4: "Role nieżywych graczy:",
    5: "Witamy Pana Burmistrza!",
    6: "Wybierz kogo chcesz zabić:",
    7: "Co tam Wieśniku? Na pole?"
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          textToRole[widget.playerRoleId]!.toUpperCase(),
          style: GoogleFonts.aboreto(
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.players.getPlayerCount(),
              itemBuilder: (context, index) {
                final player = widget.players.players[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: ORANGE,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        player.getPlayerName().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}