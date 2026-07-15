import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagres_radio/app/bootstrap.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/playback_status.dart';

import '../../fakes/fake_audio_player.dart';

void main() {
  late FakeAudioPlayer player;

  setUp(() => player = FakeAudioPlayer());
  tearDown(() => player.dispose());

  testWidgets('exibe a experiência inicial da rádio', (tester) async {
    await tester.pumpWidget(buildTestableApp(player));

    expect(find.text('AM 730'), findsWidgets);
    expect(find.text('Toque para ouvir'), findsOneWidget);
    expect(find.byKey(const Key('live-play-button')), findsOneWidget);
    expect(find.byKey(const Key('live-waves-paused')), findsOneWidget);
    expect(find.byKey(const Key('live-equalizer-paused')), findsOneWidget);
    expect(find.byKey(const Key('play-button-static')), findsOneWidget);
  });

  testWidgets('aciona player e reflete reprodução', (tester) async {
    await tester.pumpWidget(buildTestableApp(player));

    await tester.tap(find.byKey(const Key('live-play-button')));
    await tester.pump();
    expect(player.playCalls, 1);

    player.emit(const PlaybackSnapshot(PlaybackStatus.playing));
    await tester.pump();
    expect(find.text('Transmitindo ao vivo'), findsOneWidget);
    expect(find.byKey(const Key('live-waves-playing')), findsOneWidget);
    expect(find.byKey(const Key('live-equalizer-playing')), findsOneWidget);
    expect(find.byKey(const Key('play-button-animated')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byKey(const Key('live-play-button')));
    await tester.pump();
    expect(find.byKey(const Key('live-waves-paused')), findsOneWidget);
    expect(find.byKey(const Key('live-equalizer-paused')), findsOneWidget);
    expect(find.byKey(const Key('play-button-static')), findsOneWidget);
  });

  testWidgets('exibe falha e permite tentar novamente', (tester) async {
    await tester.pumpWidget(buildTestableApp(player));
    player.emit(
      const PlaybackSnapshot(PlaybackStatus.failure, message: 'Sem conexão.'),
    );
    await tester.pump();

    expect(find.text('Sem conexão.'), findsOneWidget);
    expect(find.byKey(const Key('retry-button')), findsOneWidget);
  });

  testWidgets('navega entre os quatro blocos da POC', (tester) async {
    await tester.pumpWidget(buildTestableApp(player));

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
