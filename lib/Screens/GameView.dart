import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Widgets/NightVotingWidget.dart';
import 'package:mafia/Widgets/Wrapper.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Classes/PlayerList.dart';
import '../Services/SupabaseServices.dart';

class GameView extends StatefulWidget {
  final int playerId;
  final int gameId;
  final bool isHost;

  const GameView({
    Key? key,
    required this.playerId,
    required this.isHost,
    required this.gameId,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  SupabaseServices supabaseServices = SupabaseServices();
  Player? player;
  late PlayerList allPlayers;
  bool isLoading = true;
  int votingTime = 2;
  CountDownController _controller = CountDownController();
  bool votingStart = false;
  bool votingEnd = false;
  bool dayNightSwitch = true;

  Player? choice;

  @override
  void initState() {
    _loadPlayerData();
    supabaseServices.unsubscriveAllChanels();
    super.initState();
  }

  Future<void> _loadPlayerData() async {
    List<Player> fetchedPlayers = await supabaseServices.getAllPlayerData(widget.gameId);
    int time = await supabaseServices.getGameVotingTimeById(widget.gameId);
    setState(() {
      allPlayers = PlayerList(players: fetchedPlayers);
      player = allPlayers.getPlayerById(widget.playerId);
      isLoading = false;
      votingTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    supabaseServices.subscribeToGameplay(widget.gameId, (started) async {
      if(started && dayNightSwitch){
        startNightVoting();
      } else if (started && !dayNightSwitch){
        startDayVoting();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset : false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "${player!.getPlayerRole()?.toUpperCase()}",
                  style: GoogleFonts.shadowsIntoLight(
                    textStyle: const TextStyle(
                      fontSize: 50,
                      color: ORANGE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: player!.getPlayerRoleId() == 6,
              child: Text(
                  allPlayers.getMafiaNames(widget.playerId),
                  style: const TextStyle(
                    color: ORANGE,
                    fontSize: 20,
                  )
              ),
            ),
            Expanded(
                child: Wrapper(
                    votingStart: votingStart,
                    votingEnd: votingEnd,
                    dayNightSwitch: dayNightSwitch,
                    players: allPlayers,
                    playerRoleId: player!.getPlayerRoleId(),
                    playerId: widget.playerId,
                    gameId: widget.gameId,
                    isHost: widget.isHost,
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.isHost,
                    child:  dayNightSwitch ? ElevatedButton(
                      onPressed: votingStart ? null : () {
                        supabaseServices.updateVotingInGameplay(widget.gameId);
                        supabaseServices.clearNightVote(widget.gameId);
                      },
                      child: const Text(
                        "Miasto idzie spać",
                      ),
                    )
                        : ElevatedButton(
                      onPressed: votingStart ? null : () {
                        supabaseServices.updateVotingInGameplay(widget.gameId);
                        supabaseServices.clearDayVote(widget.gameId);
                        // startDayVoting();
                      },
                      child: const Text(
                        "Głosowanie",
                      ),
                    ),
                  ),
                  CircularCountDownTimer(
                    controller: _controller,
                    width: 100,
                    height: 100,
                    duration: votingTime * 60,
                    isReverse: true,
                    isReverseAnimation: true,
                    autoStart: false,
                    fillColor: ORANGE,
                    ringColor: Colors.white12,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ORANGE,
                    ),
                    timeFormatterFunction: (defaultFormatterFunction, duration) {
                      return "${duration.inMinutes.toStringAsFixed(0).padLeft(2,'0')}"
                          " : ${(duration.inSeconds % 60).toStringAsFixed(0).padLeft(2,'0')}";
                    },
                    onComplete: onVotingEnd,
                  ),
                ],
              ),
            ),
        ],
        ),
      ),
    );
  }

  void startNightVoting(){
    _controller.start();
    setState(() {
      votingStart = true;
    });
  }
  void startDayVoting(){
    _controller.start();
    setState(() {
      votingStart = true;
    });
  }

  void onVotingEnd(){
    setState(() {
      votingStart = false;
      votingEnd = true;
      dayNightSwitch = !dayNightSwitch;
    });
    if(widget.isHost){
      supabaseServices.updateVotingInGameplay(widget.gameId);
    }
  }

  //TODO logika gry, zabijanie, ratowanie i cale to gówno
}