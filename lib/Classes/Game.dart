class Game {
  int gameId;
  String gameCode;
  int status;
  String createdAt;
  int votingTime;

  Game({
    required this.gameId,
    required this.gameCode,
    required this.status,
    required this.createdAt,
    required this.votingTime,
  });

  Game copyWith({
    int? gameId,
    String? gameCode,
    int? status,
    String? createdAt,
    int? votingTime,
  }) {
    return Game(
      gameId : gameId ?? this.gameId,
      gameCode : gameCode ?? this.gameCode,
      status : status ?? this.status,
      createdAt : createdAt ?? this.createdAt,
      votingTime : votingTime ?? this.votingTime,
    );
  }
}