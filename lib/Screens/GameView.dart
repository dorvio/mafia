import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class GameView extends StatefulWidget {
  final int playerId;
  final bool isHost;

  const GameView({
    Key? key,
    required this.playerId,
    required this.isHost,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  SupabaseServices supabaseServices = SupabaseServices();
  Player? player;
  bool isLoading = true;
  int votingTime = 2;
  CountDownController _controller = CountDownController();
  bool showVoting = false;

  @override
  void initState() {
    _loadPlayerData();
    super.initState();
  }

  Future<void> _loadPlayerData() async {
    Player? fetchedPlayer = await supabaseServices.getPlayerDataById(widget.playerId);
    int time = await supabaseServices.getGameVotingTimeById(fetchedPlayer!.getGameId());
    setState(() {
      player = fetchedPlayer;
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

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset : false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child:
                Text(
                  "${player!.getPlayerRole()?.toUpperCase()}",
                  style: GoogleFonts.shadowsIntoLight (
                    textStyle: const TextStyle(
                    fontSize: 50,
                    color: ORANGE,
                    fontWeight: FontWeight.bold
                    ),
                  )
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: widget.isHost,
                  child: ElevatedButton(
                    onPressed: () {
                      startNightVoting();
                    },
                    child: Text(
                      "Miasto idzie spać",
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
                  ringColor: ORANGE,
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ORANGE,
                  ),
                  timeFormatterFunction: (defaultFormatterFunction, duration) {
                    return "${duration.inMinutes} : ${duration.inSeconds % 60}";
                  },
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

  void startNightVoting(){
    _controller.start();
    setState(() {
      showVoting = true;
    });
  }

  //TODO dodać listiner jakies coś na bazie na start rundy startowanie głosowania/odliczania z listenera i ogólnie gre + ew animacje
}