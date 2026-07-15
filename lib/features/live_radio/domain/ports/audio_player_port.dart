import '../entities/live_station.dart';
import '../entities/playback_status.dart';

abstract interface class AudioPlayerPort {
  Stream<PlaybackSnapshot> get playback;

  Future<void> play(LiveStation station);
  Future<void> pause();
  Future<void> stop();
  Future<void> dispose();
}
