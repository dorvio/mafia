class Player {
  int playerId;
  String playerName;
  String playerRole;

  Player({
    required this.playerId,
    required this.playerName,
    required this.playerRole,
  });

  Player copyWith({
    int? playerId,
    String? playerName,
    String? playerRole,
  }) {
    return Player(
      playerId : playerId ?? this.playerId,
      playerName : playerName ?? this.playerName,
      playerRole : playerRole ?? this.playerRole,
    );
  }
}