import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class DayVotingWidget extends StatefulWidget {
  final PlayerList players;
  final int playerRoleId;
  final int playerId;
  final int gameId;


  const DayVotingWidget({
    Key? key,
    required this.players,
    required this.playerRoleId,
    required this.playerId,
    required this.gameId,
  }) : super(key: key);

  @override
  _DayVotingWidgetState createState() => _DayVotingWidgetState();
}

class _DayVotingWidgetState extends State<DayVotingWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  int selectedId = -1;
  late Map<int, int> dayVotes;
  late List<Player> alivePlayers;

  @override
  void initState() {
    super.initState();

    alivePlayers = widget.players.getAlivePlayers();
    dayVotes = {
      for (int i = 0; i < widget.players.getPlayerCount(); i++) widget.players.getIdByIndex(i): 0,
    };
  }

  @override
  void dispose(){
    supabaseServices.updatePlayerDayVote(widget.playerId, selectedId);
    supabaseServices.unsubscribeToPlayerDayVote();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Player> alivePlayers = widget.players.getAlivePlayers();

    supabaseServices.subscribeToPlayerDayVote(
      widget.gameId,
      widget.players.players,
          (Map<int, int> newVotes) {
        setState(() {
          dayVotes = newVotes;
        });
      },
    );

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          "Kogo powiesić za bycie mafią:",
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
              itemCount: alivePlayers.length,
              itemBuilder: (context, index) {
                final player = alivePlayers[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if(selectedId == index){
                        onDeselect(index);
                        supabaseServices.updatePlayerDayVote(widget.playerId, null);
                      } else if(selectedId == -1){
                        onSelect(index);
                        supabaseServices.updatePlayerDayVote(widget.playerId, alivePlayers[index].getPlayerId());
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            player.getPlayerName().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            dayVotes[player.getPlayerId()].toString(),
                            //TODO add count vote
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
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
  }

  void onDeselect(int index){
    setState(() {
      selectedId = -1;
    });
  }

}