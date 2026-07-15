import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/sagres_theme.dart';
import '../domain/entities/playback_status.dart';
import '../../schedule/infrastructure/in_memory_schedule_repository.dart';
import 'providers/live_radio_providers.dart';

class LiveRadioScreen extends ConsumerWidget {
  const LiveRadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveRadioControllerProvider);
    final controller = ref.read(liveRadioControllerProvider.notifier);
    final program = InMemoryScheduleRepository().currentProgram(DateTime.now());

    return CustomScrollView(
      key: const Key('live-radio-screen'),
      slivers: [
        SliverToBoxAdapter(
          child: _RadioHero(state: state, onToggle: controller.toggle),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          sliver: SliverList.list(
            children: [
              const _SectionTitle(title: 'Agora no ar'),
              const SizedBox(height: 10),
              _ProgramCard(
                time: program?.formattedTime ?? '--h',
                title: program?.title ?? 'Rádio Sagres ao vivo',
                subtitle: program?.host ?? 'Transmissão oficial',
                highlighted: true,
              ),
              const SizedBox(height: 26),
              const _SectionTitle(title: 'A seguir'),
              const SizedBox(height: 10),
              ...InMemoryScheduleRepository()
                  .programsFor(DateTime.now())
                  .take(3)
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _ProgramCard(
                        time: item.formattedTime,
                        title: item.title,
                        subtitle: item.host,
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              const _PocNotice(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _RadioHero extends StatelessWidget {
  const _RadioHero({required this.state, required this.onToggle});

  final LiveRadioState state;
  final Future<void> Function() onToggle;

  @override
  Widget build(BuildContext context) {
    final status = state.playback.status;
    final isPlaying = status == PlaybackStatus.playing;
    final isLoading = status == PlaybackStatus.loading;
    final hasError = status == PlaybackStatus.failure;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SagresColors.red, SagresColors.deepRed],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Column(
            children: [
              const Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SAGRES',
                        style: TextStyle(
                          color: SagresColors.yellow,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      Text(
                        'AM 730',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Chip(
                    avatar: Icon(
                      Icons.circle,
                      size: 10,
                      color: SagresColors.red,
                    ),
                    label: Text('AO VIVO'),
                    backgroundColor: SagresColors.yellow,
                    side: BorderSide.none,
                    labelStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: SagresColors.deepRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _StationArtwork(),
              const SizedBox(height: 18),
              Text(
                state.station.tagline,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: isPlaying
                    ? 'Pausar rádio ao vivo'
                    : 'Ouvir rádio ao vivo',
                child: FilledButton(
                  key: const Key('live-play-button'),
                  onPressed: isLoading ? null : onToggle,
                  style: FilledButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize: const Size(72, 72),
                    backgroundColor: SagresColors.yellow,
                    foregroundColor: SagresColors.deepRed,
                  ),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 27,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: SagresColors.deepRed,
                          ),
                        )
                      : Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 36,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                hasError
                    ? state.playback.message ?? 'Falha na transmissão.'
                    : isPlaying
                    ? 'Transmitindo ao vivo'
                    : isLoading
                    ? 'Conectando…'
                    : 'Toque para ouvir',
                key: const Key('playback-label'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: hasError ? SagresColors.yellow : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (hasError)
                TextButton(
                  key: const Key('retry-button'),
                  onPressed: onToggle,
                  child: const Text(
                    'Tentar novamente',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationArtwork extends StatelessWidget {
  const _StationArtwork();

  @override
  Widget build(BuildContext context) => Container(
    width: 190,
    height: 190,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: SagresColors.deepRed,
      border: Border.all(color: SagresColors.yellow, width: 5),
      boxShadow: const [
        BoxShadow(color: Colors.black38, blurRadius: 24, offset: Offset(0, 12)),
      ],
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.graphic_eq, color: SagresColors.yellow, size: 54),
        Text(
          'sagres',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          'AM 730',
          style: TextStyle(
            color: SagresColors.yellow,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleMedium);
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.time,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
  });

  final String time;
  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Card(
    color: highlighted
        ? SagresColors.yellow.withValues(alpha: .22)
        : Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: highlighted ? SagresColors.red : const Color(0xFFF7EEE8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: highlighted ? Colors.white : SagresColors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _PocNotice extends StatelessWidget {
  const _PocNotice();

  @override
  Widget build(BuildContext context) => const Card(
    color: Color(0xFFFFF0CF),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, color: SagresColors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'POC: programação, notícias e perfil usam dados demonstrativos. '
              'A transmissão de áudio utiliza o stream oficial da Sagres.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    ),
  );
}
