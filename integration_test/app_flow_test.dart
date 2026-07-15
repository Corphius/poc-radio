import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sagres_radio/app/bootstrap.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/live_station.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/playback_status.dart';
import 'package:sagres_radio/features/live_radio/domain/ports/audio_player_port.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo crítico da POC', (tester) async {
    final player = _E2eAudioPlayer();
    await tester.pumpWidget(buildTestableApp(player));

    expect(find.byKey(const Key('live-radio-screen')), findsOneWidget);
    await tester.tap(find.byKey(const Key('live-play-button')));
    await tester.pump();
    expect(find.text('Transmitindo ao vivo'), findsOneWidget);

    await tester.tap(find.byKey(const Key('live-play-button')));
    await tester.pump();
    expect(find.text('Toque para ouvir'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-schedule')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('schedule-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-news')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('news-screen')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-profile')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile-screen')), findsOneWidget);
  });
}

class _E2eAudioPlayer implements AudioPlayerPort {
  final _controller = Stream<PlaybackSnapshot>.multi((controller) {
    _emit = controller.add;
  });
  static void Function(PlaybackSnapshot)? _emit;

  @override
  Stream<PlaybackSnapshot> get playback => _controller;

  @override
  Future<void> play(LiveStation station) async =>
      _emit?.call(const PlaybackSnapshot(PlaybackStatus.playing));

  @override
  Future<void> pause() async =>
      _emit?.call(const PlaybackSnapshot(PlaybackStatus.paused));

  @override
  Future<void> stop() async =>
      _emit?.call(const PlaybackSnapshot(PlaybackStatus.idle));

  @override
  Future<void> dispose() async {}
}
