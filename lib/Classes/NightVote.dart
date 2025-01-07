class NightVote {
  int playerId;
  int roleId;
  int vote;

  NightVote({
    required this.playerId,
    required this.roleId,
    required this.vote,
  });

  NightVote copyWith({
    int? playerId,
    int? roleId,
    int? vote,
  }) {
    return NightVote(
      playerId : playerId ?? this.playerId,
      roleId : roleId ?? this.roleId,
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

}