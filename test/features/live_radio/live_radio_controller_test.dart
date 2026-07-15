import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagres_radio/core/errors/playback_failure.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/live_station.dart';
import 'package:sagres_radio/features/live_radio/domain/entities/playback_status.dart';
import 'package:sagres_radio/features/live_radio/presentation/providers/live_radio_providers.dart';

import '../../fakes/fake_audio_player.dart';

void main() {
  late FakeAudioPlayer player;
  late ProviderContainer container;

  setUp(() {
    player = FakeAudioPlayer();
    container = ProviderContainer(
      overrides: [audioPlayerPortProvider.overrideWithValue(player)],
    );
    addTearDown(container.dispose);
    addTearDown(player.dispose);
  });

  test('inicia a estação Sagres oficial', () async {
    final controller = container.read(liveRadioControllerProvider.notifier);

    await controller.play();

    expect(player.playCalls, 1);
    expect(player.lastStation?.streamUrl, LiveStation.sagres.streamUrl);
    expect(
      container.read(liveRadioControllerProvider).playback.status,
      PlaybackStatus.loading,
    );
  });

  test('ignora play duplicado durante carregamento', () async {
    final controller = container.read(liveRadioControllerProvider.notifier);

    await controller.play();
    await controller.play();

    expect(player.playCalls, 1);
  });

  test('reflete os estados publicados pelo adaptador', () async {
    container.read(liveRadioControllerProvider);

    player.emit(const PlaybackSnapshot(PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(liveRadioControllerProvider).playback.status,
      PlaybackStatus.playing,
    );
  });

  test('converte falha do player em estado apresentável', () async {
    player.playError = const PlaybackFailure('Stream indisponível.');
    final controller = container.read(liveRadioControllerProvider.notifier);

    await controller.play();

    final playback = container.read(liveRadioControllerProvider).playback;
    expect(playback.status, PlaybackStatus.failure);
    expect(playback.message, 'Stream indisponível.');
  });

  test('toggle pausa quando a rádio está tocando', () async {
    final controller = container.read(liveRadioControllerProvider.notifier);
    player.emit(const PlaybackSnapshot(PlaybackStatus.playing));
    await Future<void>.delayed(Duration.zero);

    await controller.toggle();

    expect(player.pauseCalls, 1);
  });
}
