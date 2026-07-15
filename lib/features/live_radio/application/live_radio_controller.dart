import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/playback_failure.dart';
import '../domain/entities/live_station.dart';
import '../domain/entities/playback_status.dart';
import '../domain/ports/audio_player_port.dart';

class LiveRadioState {
  const LiveRadioState({
    required this.station,
    this.playback = PlaybackSnapshot.idle,
  });

  final LiveStation station;
  final PlaybackSnapshot playback;

  LiveRadioState copyWith({PlaybackSnapshot? playback}) =>
      LiveRadioState(station: station, playback: playback ?? this.playback);
}

class LiveRadioController extends Notifier<LiveRadioState> {
  StreamSubscription<PlaybackSnapshot>? _subscription;

  AudioPlayerPort get _player => ref.read(audioPlayerPortProvider);

  @override
  LiveRadioState build() {
    final player = ref.watch(audioPlayerPortProvider);
    _subscription?.cancel();
    _subscription = player.playback.listen(
      (snapshot) => state = state.copyWith(playback: snapshot),
    );
    ref.onDispose(() => _subscription?.cancel());
    return LiveRadioState(station: LiveStation.sagres);
  }

  Future<void> play() async {
    if (state.playback.status == PlaybackStatus.loading ||
        state.playback.status == PlaybackStatus.playing) {
      return;
    }
    state = state.copyWith(
      playback: const PlaybackSnapshot(PlaybackStatus.loading),
    );
    try {
      await _player.play(state.station);
    } catch (error) {
      state = state.copyWith(
        playback: PlaybackSnapshot(
          PlaybackStatus.failure,
          message: error is PlaybackFailure
              ? error.message
              : 'Não foi possível conectar à transmissão.',
        ),
      );
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> toggle() =>
      state.playback.status == PlaybackStatus.playing ? pause() : play();
}

final audioPlayerPortProvider = Provider<AudioPlayerPort>(
  (ref) => throw StateError('AudioPlayerPort precisa ser configurado.'),
);

final liveRadioControllerProvider =
    NotifierProvider<LiveRadioController, LiveRadioState>(
      LiveRadioController.new,
    );
