import 'dart:async';

import 'package:sagres_radio/features/live_radio/domain/entities/live_station.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/playback_status.dart';
import 'package:sagres_radio/features/live_radio/domain/ports/audio_player_port.dart';

class FakeAudioPlayer implements AudioPlayerPort {
  final _controller = StreamController<PlaybackSnapshot>.broadcast();
  Object? playError;
  var playCalls = 0;
  var pauseCalls = 0;
  LiveStation? lastStation;

  @override
  Stream<PlaybackSnapshot> get playback => _controller.stream;

  void emit(PlaybackSnapshot snapshot) => _controller.add(snapshot);

  @override
  Future<void> play(LiveStation station) async {
    playCalls++;
    lastStation = station;
    if (playError case final error?) throw error;
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    emit(const PlaybackSnapshot(PlaybackStatus.paused));
  }

  @override
  Future<void> stop() async => emit(PlaybackSnapshot.idle);

  @override
  Future<void> dispose() => _controller.close();
}
