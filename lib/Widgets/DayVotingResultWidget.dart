import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class DayVotingResultWidget extends StatefulWidget {
  final PlayerList players;
  final int gameId;
  final bool isHost;


  const DayVotingResultWidget({
    Key? key,
    required this.players,
    required this.gameId,
    required this.isHost,
  }) : super(key: key);

  @override
  _DayVotingResultWidgetState createState() => _DayVotingResultWidgetState();
}

class _DayVotingResultWidgetState extends State<DayVotingResultWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  bool isLoading = true;
  Map<int, int> votes = {};
  late int deadPlayerId;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    Map<int, int> fetchVotes = await supabaseServices.getPlayersDayVotes(widget.gameId);
    int id = calculateDeadPlayer(fetchVotes);
    setState(() {
      votes = fetchVotes;
      deadPlayerId = id;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Player> alivePlayers = widget.players.getAlivePlayers();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          deadPlayerId == -1 ? "" : "Powieszono gracza:",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          deadPlayerId == -1 ? "Nikt nie zginął" : widget.players.getPlayerNameById(deadPlayerId),
          style: const TextStyle(
            fontSize: 30,
            color: ORANGE,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: alivePlayers.length,
                itemBuilder: (context, index){
                  final player = alivePlayers[index];
                  return Column(
                    children: [
                      Container(
                        color: ORANGE,
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            votes[player.getPlayerId()] == -1 ? "${player.getPlayerName()} nie zagłosował" :
                            "${player.getPlayerName()} zagłosował na ${widget.players.getPlayerNameById(votes[player.getPlayerId()]!)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
        ),
      ],
    );
  }

  int calculateDeadPlayer(Map<int, int> votesToCalculate) {
    //TODO do uwzględnienia remis
    Map<int, int> frequencyMap = {};

    for (var value in votesToCalculate.values) {
      if (value != -1) {
        frequencyMap[value] = (frequencyMap[value] ?? 0) + 1;
      }
    }

    if (frequencyMap.isEmpty) {
      return -1;
    }
    int mostFrequentValue = -1;
    int maxFrequency = 0;

    frequencyMap.forEach((key, value) {
      if (value > maxFrequency) {
        maxFrequency = value;
        mostFrequentValue = key;
      }
    });

    if(widget.isHost){
      mostFrequentValue == -1 ? null : supabaseServices.updateDeadPlayer(mostFrequentValue);
    }
    return mostFrequentValue;
  }

}