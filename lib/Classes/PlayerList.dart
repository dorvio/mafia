import 'Player.dart';

class PlayerList {
  List<Player> players;

  PlayerList({
    required this.players
  });

  Player getPlayerById(int id){
    return players.firstWhere((player) => player.playerId == id);
  }

  String getPlayerNameById(int id){
    Player fetchedPlayer = getPlayerById(id);
    return fetchedPlayer.getPlayerName();
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

  List<Player> getDeadPlayers(){
    return players.where((player) => player.getIsDead() == true).toList();
  }

  List<Player> getAlivePlayers(){
    return players.where((player) => player.getIsDead() == false).toList();
  }

  int getIdByIndex(int index){
    return players[index].playerId;
  }

}