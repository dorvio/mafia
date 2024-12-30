import 'dart:math';

import 'package:mafia/Classes/Game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Classes/Player.dart';

class SupabaseServices {
  final SupabaseClient supabase = Supabase.instance.client;
  late RealtimeChannel playerChannel;
  late RealtimeChannel mafiaVoteChannel;
  late RealtimeChannel dayVoteChannel;
  late RealtimeChannel gameChannel;
  late RealtimeChannel gameplayChannel;
  int playersCount = 1;
  bool voting = false;
  int alivePlayers = 0;

  Map<int, int> dayVotes = {};
  Map<int, int> nightVotes = {};

  Future<Game?> createGame() async {
    try {
      final response = await supabase.from('games').insert({
        'game_code': generateGameCode(),
      }).select().single();
      Game game = new Game(gameId: response['id'],
          gameCode: response['game_code'],
          status: response['status'],
          createdAt: response['created_at'],
          votingTime: response['voting_time']);
      return game;
    } catch (e) {
      print("Error inserting into 'games': $e");
      return null;
    }
  }

  Future <void> deleteGame(gameId) async {
    try {
      final response = await supabase.from('games').delete()
          .eq('id', gameId);
    } catch (e) {
      print("Error deleting from 'games': $e");
    }
  }

  Future<int> getGameIdByCode(String gameCode) async {
    try {
      final data = await supabase
          .from('games')
          .select()
          .eq('game_code', gameCode)
          .eq('status', 0)
          .single();
      return data['id'] as int;
    } catch (e) {
      print("Error finding game by code': $e");
      return -1;
    }
  }

  Future<int> getGameVotingTimeById(int gameId) async {
    try {
      final data = await supabase
          .from('games')
          .select()
          .eq('id', gameId)
          .single();
      return data['voting_time'] as int;
    } catch (e) {
      print("Error finding game by id': $e");
      return -1;
    }
  }

  Future <bool> updateGameStatus(int gameId, int gameStatus) async {
    try {
      final response = await supabase.from('games')
          .update({'status': gameStatus})
          .eq('id', gameId);
      return true;
    } catch (e) {
      print("Error updating game status': $e");
      return false;
    }
  }

  void subscribeToGamesStatus(int gameId,
      Function(int newStatus) onGameStatusChanged) {
    gameChannel = supabase.channel('game-status-$gameId');

    gameChannel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'games',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: gameId,
      ),
      callback: (PostgresChangePayload payload) {
        final newStatus = payload.newRecord?['status'] as int? ?? 0;
        print("Game status updated: $newStatus for game $gameId");
        onGameStatusChanged(newStatus);
      },
    );
    gameChannel.subscribe();
  }


  void unsubscribeFromGameStatus() {
    supabase.removeChannel(gameplayChannel);
  }

  Future<int> createPlayer(String _playerName, int _gameId) async {
    try {
      final response = await supabase.from('players').insert({
        'player_name': _playerName,
        'game_id': _gameId,
      }).select().single();
      return response['id'] as int;
    } catch (e) {
      print("Error inserting into 'games': $e");
      return -1;
    }
  }

  Future <void> deletePlayer(playerId) async {
    try {
      final response = await supabase.from('players').delete()
          .eq('id', playerId);
    } catch (e) {
      print("Error deleting from 'players': $e");
    }
  }

  Future<int> getNumberOfPlayerForGame(int gameId) async {
    try {
      final response = await supabase
          .from('players')
          .select('id')
          .eq('game_id', gameId)
          .count();
      return response.count;
    } catch (e) {
      print("Error geting players number for game: $e");
      return -1;
    }
  }

  Future<int> getAlivePlayerCount(int gameId) async {
    try {
      final response = await supabase
          .from('players')
          .select('id')
          .eq('game_id', gameId)
          .eq('is_dead', false)
          .count();
      return response.count;
    } catch (e) {
      print("Error geting players number for game: $e");
      return -1;
    }
  }

  void subscribeToPlayerChanges(int gameId,
      Function(int playerCount) onPlayerCountChanged) async {
    playerChannel = supabase.channel('game-lobby-$gameId');

    playerChannel
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'players',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'game_id',
        value: gameId,
      ),
      callback: (PostgresChangePayload payload) {
        print("Player added: ${payload.newRecord}");
        playersCount++;
        onPlayerCountChanged(playersCount);
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'players',
      callback: (PostgresChangePayload payload) async {
        print("Player removed");
        int num = await getNumberOfPlayerForGame(gameId);
        if (num == -1) {
          print("Cos poszlo nie tak");
        } else {
          playersCount = num;
        }
        onPlayerCountChanged(playersCount);
      },
    );

    playerChannel.subscribe();
  }

  void unsubscribeFromPlayerChanges() {
    supabase.removeChannel(playerChannel);
  }

  Future<Player?> getPlayerDataById(int playerId) async {
    try {
      final response = await supabase.from('players').select()
          .eq('id', playerId)
          .single();
      Player player = Player(playerId: playerId,
          playerName: response['player_name'],
          playerRole: response['player_role'],
          isDead: response['is_dead']);
      return player;
    } catch (e) {
      print("Error fetching player with id $playerId: $e");
      return null;
    }
  }

  Future<List<Player>> getAllPlayerData(int gameId) async {
    try {
      final response = await supabase
          .from('players')
          .select()
          .eq('game_id', gameId);

      List<Player> players = List<Player>.from(
        response.map((playerData) =>
            Player(
              playerId: playerData['id'],
              playerName: playerData['player_name'],
              playerRole: playerData['player_role'],
              isDead: playerData['is_dead'],
            )),
      );

      return players;
    } catch (e) {
      print("Error fetching players with game id $gameId: $e");
      return [];
    }
  }

  Future<List<int>> getPlayersIdsForGame(int gameId) async {
    final response = await supabase
        .from('players')
        .select('id')
        .eq('game_id', gameId);

    return (response as List)
        .map<int>((player) => player['id'] as int)
        .toList();
  }

  Future<void> updatePlayerRole(int playerId, int role) async {
    try {
      final response = await supabase
          .from('players')
          .update({'player_role': role})
          .eq('id', playerId);
    } catch (e) {
      print("Error updating player role: $e");
    }
  }

  void unsubscriveAllChanels() {
    supabase.removeAllChannels();
  }

  String generateGameCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();

    return List.generate(8, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> assignRoles(List<int> availableRoles, int gameId) async {
    int mafiaCount;
    int notMafiaPlayers;
    int notMafiaRoles;
    int villagers;
    List<int> rolesToAssign = [];
    List<int> playersIds = [];

    if (playersCount < 5) {
      mafiaCount = 1;
    } else if (playersCount < 8) {
      mafiaCount = 2;
    } else {
      mafiaCount = 3;
    }
    for (int i = 0; i < mafiaCount; ++i) {
      rolesToAssign.add(6);
    }
    notMafiaPlayers = playersCount - mafiaCount;
    if (availableRoles.length >= notMafiaPlayers) {
      notMafiaRoles = notMafiaPlayers;
      villagers = 0;
    } else {
      notMafiaRoles = availableRoles.length;
      villagers = notMafiaPlayers - notMafiaRoles;
    }
    for (int i = 0; i < notMafiaRoles; ++i) {
      rolesToAssign.add(availableRoles[i]);
    }
    for (int i = 0; i < villagers; ++i) {
      rolesToAssign.add(7);
    }
    rolesToAssign.shuffle();

    playersIds = await getPlayersIdsForGame(gameId);

    for (int i = 0; i < playersCount; ++i) {
      await updatePlayerRole(playersIds[i], rolesToAssign[i]);
    }
  }

  void subscribeToGameplay(int gameId, Function(bool started) onVotingStarted) {
    gameplayChannel = supabase.channel('gameplay-voting-$gameId');

    gameplayChannel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'gameplay',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: gameId,
      ),
      callback: (PostgresChangePayload payload) {
        final started = payload.newRecord?['voting'] as bool? ?? false;
        print("Gameplay voting changed: $started for game $gameId");
        onVotingStarted(started);
      },
    );
    gameplayChannel.subscribe();
  }

  void unsubscribeToGameplay() {
    supabase.removeChannel(gameplayChannel);
  }

  Future<void> subscribeToPlayerVoteMafia(int gameId, int alivePlayersCount,
      Function(Map<int, int> dayVotes) onVoteChanged) async {
    if (nightVotes.isEmpty) {
      nightVotes = {for (int i = 0; i < alivePlayersCount; i++) i: 0};
    }

    mafiaVoteChannel = supabase.channel('player-mafia-vote-$gameId');

    mafiaVoteChannel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'vote',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'game_id',
        value: gameId,
      ),
      callback: (PostgresChangePayload payload) {
        final newRecord = payload.newRecord;
        final oldRecord = payload.oldRecord;
        print(newRecord);
        if (newRecord != null && newRecord['night_vote'] != null && newRecord['role_id'] == 6) {
          final newVote = newRecord['night_vote'] as int;
          nightVotes[newVote] = (nightVotes[newVote] ?? 0) + 1;
        }
        print(oldRecord);
        if (oldRecord != null && oldRecord['night_vote'] != null && oldRecord['role_id'] == 6) {
          final oldVote = oldRecord['night_vote'] as int;
          nightVotes[oldVote] = (nightVotes[oldVote] ?? 0) - 1;
        }

        onVoteChanged(nightVotes);
      },
    );

    mafiaVoteChannel.subscribe();
  }

  void unsubscribeToPlayerVoteMafia() {
    supabase.removeChannel(mafiaVoteChannel);
  }

    Future<void> subscribeToPlayerDayVote(int gameId, int alivePlayersCount,
        Function(Map<int, int> dayVotes) onVoteChanged) async {
      if (dayVotes.isEmpty) {
        dayVotes = {for (int i = 0; i < alivePlayersCount; i++) i: 0};
      }

      dayVoteChannel = supabase.channel('player-day-vote-$gameId');

      dayVoteChannel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'vote',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'game_id',
          value: gameId,
        ),
        callback: (PostgresChangePayload payload) {
          final newRecord = payload.newRecord;
          final oldRecord = payload.oldRecord;
          print(newRecord);
          if (newRecord != null && newRecord['day_vote'] != null) {
            final newVote = newRecord['day_vote'] as int;
            dayVotes[newVote] = (dayVotes[newVote] ?? 0) + 1;
          }
          print(oldRecord);
          if (oldRecord != null && oldRecord['day_vote'] != null) {
            final oldVote = oldRecord['day_vote'] as int;
            dayVotes[oldVote] = (dayVotes[oldVote] ?? 0) - 1;
          }

          onVoteChanged(dayVotes);
        },
      );

      dayVoteChannel.subscribe();
    }

    void unsubscribeToPlayerDayVote() {
      supabase.removeChannel(dayVoteChannel);
    }

    void updatePlayerDayVote(int playerId, int? vote) async {
      try {
        final response = await supabase.from('vote')
            .update({'day_vote': vote})
            .eq('player_id', playerId);
      } catch (e) {
        print("Error updating player day vote': $e");
      }
    }

    void updatePlayerNightVote(int playerId, int? vote) async {
      try {
        final response = await supabase.from('vote')
            .update({'night_vote': vote})
            .eq('player_id', playerId);
      } catch (e) {
        print("Error updating player night vote': $e");
      }
    }

    void clearDayVote(int gameId) async {
      try {
        final response = await supabase.from('vote')
            .update({'day_vote': null})
            .eq('game_id', gameId);
      } catch (e) {
        print("Error clearing day votes': $e");
      }
    }

    void clearNightVote(int gameId) async {
      try {
        final response = await supabase.from('vote')
            .update({'night_vote': null})
            .eq('game_id', gameId);
      } catch (e) {
        print("Error clearing day votes': $e");
      }
    }

    void updateVotingInGameplay(int gameId) async {
      voting = !voting;
      try {
        final response = await supabase.from('gameplay')
            .update({'voting': voting})
            .eq('id', gameId);
      } catch (e) {
        print("Error updating gameplay voting': $e");
      }
    }
  }