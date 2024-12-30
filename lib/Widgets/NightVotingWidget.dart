import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class NightVotingWidget extends StatefulWidget {
  final PlayerList players;
  final int playerRoleId;
  final int gameId;
  final int playerId;
  final Function(int vote)? onVoteChange;


  const NightVotingWidget({
    Key? key,
    required this.players,
    required this.playerRoleId,
    required this.gameId,
    required this.playerId,
    this.onVoteChange,
  }) : super(key: key);

  @override
  _NightVotingWidgetState createState() => _NightVotingWidgetState();
}

class _NightVotingWidgetState extends State<NightVotingWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  int selectedId = -1;
  List<int> mafiaChoice = [];
  late Map<int, int> nightVotes;
  late List<Player> alivePlayers;

  Map<int, String> textToRole = {
    1: "Wybierz kogo chcesz obronić:",
    2: "Zapytaj czy jest w mafii:",
    3: "Wybierz kogo zabimbrować:",
    4: "Role martwych graczy:",
    5: "Witamy Pana Burmistrza!",
    6: "Wybierz kogo chcesz zabić:",
    7: "Co tam Wieśniaku? Na pole?"
  };

  @override
  void initState() {
    alivePlayers = widget.players.getAlivePlayers();
    nightVotes = {
      for (int i = 0; i < alivePlayers.length; i++) i: 0,
    };
    super.initState();
  }

  @override
  void dispose(){
    supabaseServices.unsubscribeToPlayerVoteMafia();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    if(widget.playerRoleId == 5 || widget.playerRoleId == 7){
      //Burmistrz, Wieśniak
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
        ]
      );
    } else if(widget.playerRoleId == 4) {
      //Grabarz
      List<Player> deadPlayers = widget.players.getDeadPlayers();
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
                child: deadPlayers.isEmpty ?
                const Text("Jeszcze nikt nie umarł",
                  style: TextStyle(
                    color: ORANGE,
                    fontSize: 20,
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: deadPlayers.length,
                  itemBuilder: (context, index) {
                    final player = deadPlayers[index];
                    return Container(
                      color: ORANGE,
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "${player.getPlayerName().toUpperCase()} posiadał role: ${player.getPlayerRole()!.toUpperCase()}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]
      );
    } else if(widget.playerRoleId == 6) {
      //Mafia

      supabaseServices.subscribeToPlayerVoteMafia(
        widget.gameId,
        alivePlayers.length,
            (Map<int, int> newVotes) {
          setState(() {
            nightVotes = newVotes;
          });
        },
      );

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
                          supabaseServices.updatePlayerNightVote(widget.playerId, null);
                        } else if(selectedId == -1){
                          onSelect(index);
                          supabaseServices.updatePlayerNightVote(widget.playerId, index);
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
                              nightVotes[index].toString(),
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
    } else {
      //Obrońca, Prokurator, Bimbrownik
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