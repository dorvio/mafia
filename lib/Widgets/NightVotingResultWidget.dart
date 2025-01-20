import 'package:flutter/material.dart';
import 'package:mafia/Classes/NightVote.dart';
import 'package:mafia/Classes/NightVoteList.dart';
import 'package:mafia/Classes/PlayerList.dart';

import '../Screens/EndGameView.dart';
import '../Services/SupabaseServices.dart';
import '../constants.dart';

class NightVotingResultWidget extends StatefulWidget {
  final PlayerList players;
  final int playerId;
  final int playerRoleId;
  final int gameId;
  final bool isHost;


  const NightVotingResultWidget({
    Key? key,
    required this.players,
    required this.playerId,
    required this.playerRoleId,
    required this.gameId,
    required this.isHost,
  }) : super(key: key);

  @override
  _NightVotingResultWidgetState createState() => _NightVotingResultWidgetState();
}

class _NightVotingResultWidgetState extends State<NightVotingResultWidget> {
  SupabaseServices supabaseServices = SupabaseServices();
  bool isLoading = true;
  NightVoteList? votes;
  int prosecutorVote = -1;
  int mafiaVote = -1;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    List<NightVote> fetchVotes = await supabaseServices.getPlayersNightVotes(widget.gameId);
    NightVoteList fetchedVotesList = NightVoteList(nightVotes: fetchVotes);
    int pVote = await fetchedVotesList.getProsecutorVote();
    int mVote = await fetchedVotesList.getMafiaVote();
    setState(() {
      votes = NightVoteList(nightVotes: fetchVotes);
      prosecutorVote = pVote;
      mafiaVote = mVote;
      isLoading = false;
    });
    if(widget.isHost && mVote != -1){
      await supabaseServices.updateDeadPlayer(mVote);
      widget.players.updateDeadPlayerById(mVote);
      int endGame = widget.players.calculateEndGame();
      endGame != 0 ? supabaseServices.updateGameStatus(widget.gameId, endGame + 1) : null;
    }
  }

  @override
  Widget build(BuildContext context) {

    supabaseServices.subscribeToGamesStatus(widget.gameId, (gameStatus) async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EndGameView(endGameResult: gameStatus)),
      );
    });

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          mafiaVote == -1 ? "" : "Nad ranem znaleziono ciało:",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          mafiaVote == -1 ? "Nikt nie zginął" : widget.players.getPlayerNameById(mafiaVote),
          style: const TextStyle(
            fontSize: 30,
            color: ORANGE,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Center(
            child: Visibility(
              visible: widget.playerRoleId == 2 && !widget.players.getPlayerById(widget.playerId).getIsDead(),
                child: Text(
                  prosecutorVote == -1
                      ? "Prokurator nie oddał głosu."
                      : widget.players.checkIfPlayerIsMafia(prosecutorVote)
                      ? "Gracz ${widget.players.getPlayerNameById(prosecutorVote)} jest w mafii."
                      : "Gracz ${widget.players.getPlayerNameById(prosecutorVote)} nie jest w mafii.",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
            ),
          ),
        ),
      ],
    );
  }

}