class Player {
  int playerId;
  String playerName;
  String? playerRole;
  bool isDead;
  String createdAt;
  int gameId;

  Player({
    required this.playerId,
    required this.playerName,
    this.playerRole,
    this.isDead = false,
    required this.createdAt,
    required this.gameId,
  });

  Player copyWith({
    int? playerId,
    String? playerName,
    String? playerRole,
    bool? isDead,
    String? createdAt,
    int? gameId,
  }) {
    return Player(
      playerId : playerId ?? this.playerId,
      playerName : playerName ?? this.playerName,
      playerRole : playerRole ?? this.playerRole,
      isDead : isDead ?? this.isDead,
      createdAt : createdAt ?? this.createdAt,
      gameId : gameId ?? this.gameId,
    );
  }
}