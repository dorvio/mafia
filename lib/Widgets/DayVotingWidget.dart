import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class PlayerListWidget extends StatefulWidget {
  final PlayerList players;
  final int playerRoleId;
  final int gameId;
  final Function(int vote)? onVoteChange;


  const PlayerListWidget({
    Key? key,
    required this.players,
    required this.playerRoleId,
    required this.gameId,
    this.onVoteChange,
  }) : super(key: key);

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  int selectedId = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          "Kogo chcesz powiesić za bycie mafia?",
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
                    onPressed: () {
                      if(selectedId == index){
                        onDeselect(index);
                      } else if(selectedId == -1){
                        onSelect(index);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: selectedId == index ? ORANGE.darken(0.25) : ORANGE,
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

  void onSelect(int index){
    setState(() {
      selectedId = index;
    });
    widget.onVoteChange?.call(widget.players.getIdByIndex(index));
  }

  void onDeselect(int index){
    setState(() {
      selectedId = -1;
    });
    widget.onVoteChange?.call(widget.players.getIdByIndex(index));
  }

}