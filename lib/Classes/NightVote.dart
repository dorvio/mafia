class NightVote {
  int playerId;
  int roleId;
  int gameId;
  int vote;

  NightVote({
    required this.playerId,
    required this.roleId,
    required this.gameId,
    required this.vote,
  });

  NightVote copyWith({
    int? playerId,
    int? roleId,
    int? gameId,
    int? vote,
  }) {
    return NightVote(
      playerId : playerId ?? this.playerId,
      roleId : roleId ?? this.roleId,
      gameId : gameId ?? this.gameId,
      vote : vote ?? this.vote,
    );
  }

  int getPlayerId(){
    return playerId;
  }

  int getRoleId(){
    return roleId;
  }

  int getVote(){
    return vote;
  }

  int getGameId(){
    return gameId;
  }

}