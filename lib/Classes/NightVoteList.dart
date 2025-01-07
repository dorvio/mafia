import 'package:mafia/Classes/NightVote.dart';

class NightVoteList {
  List<NightVote> nightVotes;

  NightVoteList({
    required this.nightVotes,
  });

  int getMafiaVote(int alivePlayerCount){
    List<NightVote> mafiaVotes = nightVotes.where((vote) => vote.getRoleId() == 6).toList();
    if(mafiaVotes.length == 1){
      if(mafiaVotes[0].getPlayerId() == getAlcoholicVote()){
        return getDrunkVote(alivePlayerCount, mafiaVotes[0].getVote());
      }
      return mafiaVotes[0].getVote();
    } else {
      int mafiaVote = calculatePlayerToKill(mafiaVotes);
      if(mafiaVotes.any((vote) => vote.getPlayerId() == getAlcoholicVote())){
        return getDrunkVote(alivePlayerCount, mafiaVote);
      } else{
        return mafiaVote;
      }
    }
  }

  int getDefenderVote(int alivePlayerCount){
    NightVote defender = nightVotes.firstWhere((vote) => vote.getRoleId() == 1);
    if(defender.getPlayerId() == getAlcoholicVote()){
      return getDrunkVote(alivePlayerCount, defender.getVote());
    }
    return defender.getVote();
  }

  int getProsecutorVote(int alivePlayerCount){
    NightVote prosecutor = nightVotes.firstWhere((vote) => vote.getRoleId() == 2);
    if(prosecutor.getPlayerId() == getAlcoholicVote()){
      return getDrunkVote(alivePlayerCount, prosecutor.getVote());
    }
    return prosecutor.getVote();
  }

  int getAlcoholicVote(){
    return nightVotes.firstWhere((vote) => vote.getRoleId() == 3).getVote();
  }

  int getDrunkVote(int alivePlayerCount, int vote){
    //TODO dodać uwzględnienie martych osób - przesuwać sie po liście id
    int drunkVote = (vote + 3) % alivePlayerCount;
    return drunkVote == 0 ? alivePlayerCount : drunkVote;
  }

  int calculatePlayerToKill(List<NightVote> mafiaVotes){
    Map<int, int> voteCount = {};

    for (var vote in mafiaVotes) {
      voteCount[vote.getVote()] = (voteCount[vote.getVote()] ?? 0) + 1;
    }

    int? mostFrequentVote;
    int maxCount = 0;
    int maxCountOccurrences = 0;

    voteCount.forEach((vote, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequentVote = vote;
        maxCountOccurrences = 1;
      } else if (count == maxCount) {
        maxCountOccurrences++;
      }
    });

    if (maxCountOccurrences > 1) {
      return -1;
    }

    return mostFrequentVote!;
  }

}