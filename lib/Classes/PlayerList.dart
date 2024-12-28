import 'Player.dart';

class PlayerList {
  List<Player> players;

  PlayerList({
    required this.players
  });

  Player getPlayerById(int id){
    return players.firstWhere((player) => player.playerId == id);
  }

  String getMafiaNames(int id) {
    return players
        .where((player) => player.getPlayerRoleId() == 6)
        .where((player) => player.getPlayerId() != id)
        .map((player) => player.getPlayerName().toUpperCase())
        .join('      ');
  }

  bool checkIfPlayerIsMafia(int id) {
    Player checkedPlayer = getPlayerById(id);
    return checkedPlayer.getPlayerRoleId() == 6;
  }

  int getPlayerCount(){
    return players.length;
  }

}