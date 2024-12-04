import 'package:flutter/material.dart';

import '../Classes/Player.dart';
import '../Services/SupabaseServices.dart';

class GameView extends StatefulWidget {
  final int playerId;

  const GameView({
    Key? key,
    required this.playerId,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> with SingleTickerProviderStateMixin {
  SupabaseServices supabaseServices = SupabaseServices();
  Player? player;
  bool isLoading = true;

  @override
  void initState() {
    _loadPlayerData();
    super.initState();
  }

  Future<void> _loadPlayerData() async {
    Player? fetchedPlayer = await supabaseServices.getPlayerDataById(widget.playerId);
    setState(() {
      player = fetchedPlayer;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Text(
          "Witaj w grze ${player!.getPlayerName()}\n"
              "Twoja rola to ${player!.getPlayerRole()}",
        ),
      ),
    );
  }
}
