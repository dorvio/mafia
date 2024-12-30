import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mafia/Classes/PlayerList.dart';
import 'package:mafia/constants.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';
import 'DayVotingWidget.dart';
import 'NightVotingWidget.dart';

class Wrapper extends StatefulWidget {
  final bool votingStart;
  final bool votingEnd;
  final bool dayNightSwitch;
  final PlayerList players;
  final int playerRoleId;
  final int playerId;
  final int gameId;
  final Function(int vote)? onNightVoteChange;
  final Function(int vote)? onDayVoteChange;
  final bool isHost;


  const Wrapper({
    Key? key,
    required this.votingStart,
    required this.votingEnd,
    required this.dayNightSwitch,
    required this.players,
    required this.playerRoleId,
    required this.playerId,
    required this.gameId,
    this.onNightVoteChange,
    this.onDayVoteChange,
    required this.isHost,
  }) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  SupabaseServices supabaseServices = SupabaseServices();

  @override
  Widget build(BuildContext context) {
    //TODO dodać wyświetlanie wyników w noc i dzień
    if(widget.dayNightSwitch && widget.votingStart){
      return NightVotingWidget(players: widget.players, playerRoleId: widget.playerRoleId, gameId: widget.gameId, playerId: widget.playerId, onVoteChange: widget.onNightVoteChange,);
    } else if(widget.dayNightSwitch && widget.votingEnd){
      return Text("Tutaj wyniki z dnia");
    } else if(!widget.dayNightSwitch && widget.votingStart){
      return DayVotingWidget(players: widget.players, playerRoleId: widget.playerRoleId, playerId: widget.playerId, gameId: widget.gameId);
    } else if(!widget.dayNightSwitch && widget.votingEnd){
      return Text("Tutaj wyniki z nocy");
    } else {
      return const Text("Coś poszło nie tak",
      style: TextStyle(color: Colors.white));
    }
  }

}