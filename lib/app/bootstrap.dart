import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/live_radio/domain/ports/audio_player_port.dart';
import '../features/live_radio/infrastructure/audio/sagres_audio_handler.dart';
import '../features/live_radio/presentation/providers/live_radio_providers.dart';
import 'sagres_app.dart';

Future<void> bootstrap() async {
  final handler = await AudioService.init<SagresAudioHandler>(
    builder: SagresAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'br.org.institutosagres.sagres_radio.audio',
      androidNotificationChannelName: 'Rádio Sagres ao vivo',
      androidNotificationOngoing: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        audioPlayerPortProvider.overrideWithValue(
          AudioServicePlayerAdapter(handler),
        ),
      ],
      child: const SagresApp(),
    ),
  );
}

@visibleForTesting
Widget buildTestableApp(AudioPlayerPort player) => ProviderScope(
  overrides: [audioPlayerPortProvider.overrideWithValue(player)],
  child: const SagresApp(),
);
