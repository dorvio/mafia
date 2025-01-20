class Player {
  int playerId;
  String playerName;
  int playerRole;
  bool isDead;

  Player({
    required this.playerId,
    required this.playerName,
    required this.playerRole,
    this.isDead = false
  });

  Player copyWith({
    int? playerId,
    String? playerName,
    int? playerRole,
    bool? isDead,
  }) {
    return Player(
      playerId : playerId ?? this.playerId,
      playerName : playerName ?? this.playerName,
      playerRole : playerRole ?? this.playerRole,
      isDead : isDead ?? this.isDead,
    );
  }

  int getPlayerId(){
    return playerId;
  }

  String getPlayerName() {
    return playerName;
  }
  int getPlayerRoleId() {
    return playerRole;
  }
  String? getPlayerRole(){
    Map<int, String> roleMapping = {
      1: "Obrońca",
      2: "Prokurator",
      3: "Bimbrownik",
      4: "Grabarz",
      5: "Burmistrz",
      6: "Mafia",
      7: "Wieśniak"
    };

    return roleMapping[playerRole];
  }
  bool getIsDead() {
    return isDead;
  }

}