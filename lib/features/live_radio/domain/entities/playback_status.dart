enum PlaybackStatus { idle, loading, playing, paused, failure }

class PlaybackSnapshot {
  const PlaybackSnapshot(this.status, {this.message});

  final PlaybackStatus status;
  final String? message;

  static const idle = PlaybackSnapshot(PlaybackStatus.idle);

  @override
  bool operator ==(Object other) =>
      other is PlaybackSnapshot &&
      other.status == status &&
      other.message == message;

  @override
  int get hashCode => Object.hash(status, message);
}
