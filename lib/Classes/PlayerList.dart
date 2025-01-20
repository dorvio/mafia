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

  List<Player> getAlivePlayers() {
    return players
        .where((player) => player.getIsDead() == false)
        .toList()
      ..sort((a, b) => a.playerId.compareTo(b.playerId));
  }

  int getIdByIndex(int index){
    return players[index].playerId;
  }

  void updateDeadPlayerById(int id){
    Player deadPlayer = players.firstWhere((player) => player.getPlayerId() == id);
    int deadPlayerIndexplayers = players.indexOf(deadPlayer);
    players[deadPlayerIndexplayers].isDead = true;
  }

  int getAliveCityPlayersCount(){
    return players
        .where((player) => player.getIsDead() == false && player.getPlayerRoleId() != 6)
        .toList().length;
  }

  int getMafiaPlayersCount(){
    return players
        .where((player) =>  player.getIsDead() == false && player.getPlayerRoleId() == 6)
        .toList().length;
  }

  int calculateEndGame(){
    int cityCount = getAliveCityPlayersCount();
    int mafiaCount = getMafiaPlayersCount();
    if(mafiaCount >= cityCount){
      return 1; //mafia wins
    }
    else if(mafiaCount == 0){
      return 2; //city wins
    }
    else {
      return 0; //game continue
    }
  }

}