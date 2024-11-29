import 'dart:math';

import 'package:mafia/Classes/Game.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Classes/Player.dart';

class SupabaseServices {
  final SupabaseClient supabase = Supabase.instance.client;
  late RealtimeChannel channel;
  int playersCount = 0;

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

  Stream<int> getPlayerCountStream(int gameId) {
    return supabase
        .from('players:game_id=eq.$gameId')
        .stream(primaryKey: ['id'])
        .map((players) => players.length);
  }

  void subscribeToPlayerChanges(int gameId, Function(int playerCount) onPlayerCountChanged) {
    channel = supabase.channel('game-lobby-$gameId');

    channel.onPostgresChanges(
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
        onPlayerCountChanged(playersCount + 1);
      },
    );

    channel.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'players',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'game_id',
        value: gameId,
      ),
      callback: (PostgresChangePayload payload) {
        print("Player removed: ${payload.oldRecord}");
        onPlayerCountChanged(playersCount - 1);
      },
    );

    channel.subscribe();
  }

  void unsubscribeFromPlayerChanges() {
    supabase.removeChannel(channel);
  }

  String generateGameCode() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();

    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }


}