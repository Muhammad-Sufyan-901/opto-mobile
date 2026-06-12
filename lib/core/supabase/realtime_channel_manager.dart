import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:opto/core/supabase/supabase_client_provider.dart';

/// Manages a single Supabase Realtime channel subscription.
///
/// Instantiate one manager per BLoC / logical subscription.
/// Call [subscribe] to start receiving [PostgresChangePayload] events as a
/// stream. Call [dispose] in [Bloc.close] / cubit close to cancel the channel.
///
/// Usage:
/// ```dart
/// final manager = RealtimeChannelManager(channelName: 'connect-feed');
/// final stream = manager.subscribe(table: 'posts', event: PostgresChangeEvent.insert);
/// // ... listen to stream ...
/// await manager.dispose();
/// ```
class RealtimeChannelManager {
  RealtimeChannelManager({required this.channelName});

  final String channelName;

  RealtimeChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;

  /// Starts listening for [event] changes on [table] (and optional [schema]).
  ///
  /// Returns a broadcast [Stream] of the raw payload map. Calling this again
  /// while already subscribed is a no-op; returns the existing stream.
  Stream<Map<String, dynamic>> subscribe({
    required String table,
    required PostgresChangeEvent event,
    String schema = 'public',
  }) {
    if (_controller != null) return _controller!.stream;

    _controller = StreamController<Map<String, dynamic>>.broadcast();
    _channel = SupabaseClientProvider.client.channel(channelName);

    _channel!
        .onPostgresChanges(
          event: event,
          schema: schema,
          table: table,
          callback: (payload) {
            if (_controller != null && !_controller!.isClosed) {
              final record = payload.newRecord;
              if (record.isNotEmpty) {
                _controller!.add(record);
              }
            }
          },
        )
        .subscribe();

    return _controller!.stream;
  }

  /// Unsubscribes from the channel and closes the stream.
  ///
  /// Safe to call multiple times. Must be called in [Bloc.close].
  Future<void> dispose() async {
    await _controller?.close();
    _controller = null;
    if (_channel != null) {
      try {
        await SupabaseClientProvider.client.removeChannel(_channel!);
      } catch (_) {
        // Swallow — channel may already be removed; cleanup must continue.
      } finally {
        _channel = null;
      }
    }
  }
}
