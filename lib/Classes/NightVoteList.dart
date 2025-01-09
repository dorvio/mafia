import 'package:mafia/Classes/NightVote.dart';
import '../Services/SupabaseServices.dart';

class NightVoteList {
  List<NightVote> nightVotes;

  NightVoteList({
    required this.nightVotes,
  });

  Future<int> getMafiaVote() async {
    //TODO sprawdzenie głosu obrońcy
    List<NightVote> mafiaVotes = nightVotes.where((vote) => vote.getRoleId() == 6).toList();
    int mafiaVote = calculatePlayerToKill(mafiaVotes);
    if(mafiaVotes.any((vote) => vote.getPlayerId() == getAlcoholicVote()) && mafiaVote != -1){
      int drunkVote = await getDrunkVote(mafiaVote);
      mafiaVote = drunkVote;
    }
    int defenderVote = await getDefenderVote();
    return mafiaVote == defenderVote ? -1 : mafiaVote;
  }

  Future<int> getDefenderVote() async {
    NightVote defender = nightVotes.firstWhere((vote) => vote.getRoleId() == 1);
    if(defender.getPlayerId() == getAlcoholicVote() && defender.getVote() != -1){
      int drunkVote = await getDrunkVote(defender.getVote());
      return drunkVote;
    }
    return defender.getVote();
  }

  Future<int> getProsecutorVote() async {
    NightVote prosecutor = nightVotes.firstWhere((vote) => vote.getRoleId() == 2);
    if(prosecutor.getPlayerId() == getAlcoholicVote() && prosecutor.getVote() != -1){
      int drunkVote = await getDrunkVote(prosecutor.getVote());
      return drunkVote;
    }
    return prosecutor.getVote();
  }

  int getAlcoholicVote(){
    return nightVotes.firstWhere((vote) => vote.getRoleId() == 3).getVote();
  }

  Future<int> getDrunkVote(int vote) async {
    SupabaseServices supabaseServices = SupabaseServices();
    List<int> alivePlayersIds = await supabaseServices.getAlivePlayersId(nightVotes[0].getGameId());
    alivePlayersIds.sort();
    int startIndex = alivePlayersIds.indexOf(vote);
    int drunkIndex = (startIndex + 4) % alivePlayersIds.length;
    return drunkIndex;
  }

  int calculatePlayerToKill(List<NightVote> mafiaVotes) {
    Map<int, int> voteCount = {};

    for (var vote in mafiaVotes) {
      voteCount[vote.getVote()] = (voteCount[vote.getVote()] ?? 0) + 1;
    }

    List<MapEntry<int, int>> sortedVotes = voteCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (sortedVotes.isEmpty) {
      return -1;
    }

    int mostFrequentVote = sortedVotes.first.key;
    int maxCount = sortedVotes.first.value;


    int maxCountOccurrences = sortedVotes.where((entry) => entry.value == maxCount).length;

    if (maxCountOccurrences > 1) {
      return -1;
    }

    if (mostFrequentVote == -1 && sortedVotes.length > 1) {
      mostFrequentVote = sortedVotes[1].key;
    }

    return mostFrequentVote;
  }

}