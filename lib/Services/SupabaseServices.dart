import 'dart:math';

import 'package:mafia/Classes/Game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Classes/Player.dart';

class SupabaseServices {
  final SupabaseClient supabase = Supabase.instance.client;
  late RealtimeChannel playerChannel;
  late RealtimeChannel gameChannel;
  int playersCount = 1;

  Future<Game?> createGame() async {
    try {
      final response = await supabase.from('games').insert({
        'game_code': generateGameCode(),
      }).select().single();
      Game game = new Game(gameId: response['id'], gameCode: response['game_code'], status: response['status'], createdAt: response['created_at']);
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

  Future<int> getGameIdByCode(String _gameCode) async {
    try {
      final data = await supabase
          .from('games')
          .select()
          .eq('game_code', _gameCode)
          .eq('status', 0)
          .single();
      return data['id'] as int;
    } catch (e) {
      print("Error finding game by code': $e");
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
      print("Error finding game by code': $e");
      return false;
    }
  }

  void subscribeToGamesStatus(int gameId, Function(int newStatus) onGameStatusChanged) {
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
    supabase.removeChannel(gameChannel);
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
    try{
      final response = await supabase.from('players').delete()
          .eq('id', playerId);
    }catch (e) {
      print("Error deleting from 'players': $e");
    }
  }

  Future<int> getNumberOfPlayerForGame(int gameId) async {
    try{
      final response = await supabase
          .from('players')
          .select('id')
          .eq('game_id', gameId)
          .count();
      return response.count;
    }catch (e) {
      print("Error deleting from 'players': $e");
      return -1;
    }
  }

  void subscribeToPlayerChanges(int gameId, Function(int playerCount) onPlayerCountChanged) async {
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
        if(num == -1){
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

  void unsubscriveAllChanels() {
    supabase.removeAllChannels();
  }

  String generateGameCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();

    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }


}