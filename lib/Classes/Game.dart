class Game {
  int gameId;
  String gameCode;
  int status;
  String createdAt;

  Game({
    required this.gameId,
    required this.gameCode,
    required this.status,
    required this.createdAt,
  });

  Game copyWith({
    int? gameId,
    String? gameCode,
    int? status,
    String? createdAt,
  }) {
    return Game(
      gameId : gameId ?? this.gameId,
      gameCode : gameCode ?? this.gameCode,
      status : status ?? this.status,
      createdAt : createdAt ?? this.createdAt,
    );
  }
}