class PlaybackFailure implements Exception {
  const PlaybackFailure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'PlaybackFailure: $message';
}
