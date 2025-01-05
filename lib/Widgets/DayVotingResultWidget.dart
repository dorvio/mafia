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


  const DayVotingResultWidget({
    Key? key,
    required this.players,
    required this.gameId,
  }) : super(key: key);

  @override
  _DayVotingResultWidgetState createState() => _DayVotingResultWidgetState();
}

class _DayVotingResultWidgetState extends State<DayVotingResultWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  bool isLoading = true;
  late Map<int, int> votes;
  late int deadPlayerIndex;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    Map<int, int> fetchVotes = await supabaseServices.getPlayersDayVotes(widget.gameId);
    int index = calculateDeadPlayer();
    setState(() {
      votes = fetchVotes;
      deadPlayerIndex = index;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Player> alivePlayers = widget.players.getAlivePlayers();

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Powieszono gracza:",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          deadPlayerIndex == -1 ? alivePlayers[deadPlayerIndex].getPlayerName() : "Nikt nie zginął",
          style: const TextStyle(
            fontSize: 30,
            color: ORANGE,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: alivePlayers.length,
                itemBuilder: (context, index){
                  final player = alivePlayers[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${player.getPlayerName()} zaglosował na ${widget.players.getPlayerById(alivePlayers[index].getPlayerId())}",
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
      ],
    );
  }

  int calculateDeadPlayer(){
    int? maxKey;
    int maxValue = -1;

    votes.forEach((key, value) {
      if (value > maxValue) {
        maxValue = value;
        maxKey = key;
      }
    });

    if(maxKey == 0){
      return -1;
    } else{
      return maxKey!;

    }
  }

}