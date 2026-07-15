import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/errors/playback_failure.dart';
import '../../domain/entities/live_station.dart';
import '../../domain/entities/playback_status.dart';
import '../../domain/ports/audio_player_port.dart';

class SagresAudioHandler extends BaseAudioHandler {
  SagresAudioHandler() {
    _player.playerStateStream.listen(_broadcastState);
    _player.errorStream.listen((error) {
      _snapshotController.add(
        const PlaybackSnapshot(
          PlaybackStatus.failure,
          message: 'A transmissão foi interrompida. Tente novamente.',
        ),
      );
    });
  }

  final AudioPlayer _player = AudioPlayer();
  final StreamController<PlaybackSnapshot> _snapshotController =
      StreamController<PlaybackSnapshot>.broadcast();
  Uri? _loadedUrl;

  Stream<PlaybackSnapshot> get playback => _snapshotController.stream;

  @override
  Future<void> play() => playStation(LiveStation.sagres);

  Future<void> playStation(LiveStation target) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      if (_loadedUrl != target.streamUrl) {
        _snapshotController.add(const PlaybackSnapshot(PlaybackStatus.loading));
        mediaItem.add(
          MediaItem(
            id: target.streamUrl.toString(),
            title: '${target.name} ${target.frequency}',
            artist: target.tagline,
            isLive: true,
          ),
        );
        await _player.setUrl(target.streamUrl.toString());
        _loadedUrl = target.streamUrl;
      }
      await _player.play();
    } catch (error) {
      throw PlaybackFailure(
        'Não foi possível conectar à transmissão ao vivo.',
        error,
      );
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    _loadedUrl = null;
    return super.stop();
  }

  Future<void> dispose() async {
    await _snapshotController.close();
    await _player.dispose();
  }

  void _broadcastState(PlayerState playerState) {
    final snapshot = switch (playerState.processingState) {
      ProcessingState.loading || ProcessingState.buffering =>
        const PlaybackSnapshot(PlaybackStatus.loading),
      _ when playerState.playing => const PlaybackSnapshot(
        PlaybackStatus.playing,
      ),
      ProcessingState.ready => const PlaybackSnapshot(PlaybackStatus.paused),
      _ => PlaybackSnapshot.idle,
    };
    _snapshotController.add(snapshot);
    playbackState.add(
      PlaybackState(
        controls: [
          if (playerState.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
        ],
        androidCompactActionIndices: const [0],
        processingState: switch (playerState.processingState) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: playerState.playing,
      ),
    );
  }
}

class AudioServicePlayerAdapter implements AudioPlayerPort {
  const AudioServicePlayerAdapter(this._handler);

  final SagresAudioHandler _handler;

  @override
  Stream<PlaybackSnapshot> get playback => _handler.playback;

  @override
  Future<void> play(LiveStation station) => _handler.playStation(station);

  @override
  Future<void> pause() => _handler.pause();

  @override
  Future<void> stop() => _handler.stop();

  @override
  Future<void> dispose() => _handler.dispose();
}
