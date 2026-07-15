import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/sagres_theme.dart';
import '../../schedule/domain/entities/radio_program.dart';
import '../../schedule/infrastructure/in_memory_schedule_repository.dart';
import '../domain/entities/playback_status.dart';
import 'providers/live_radio_providers.dart';

class LiveRadioScreen extends ConsumerWidget {
  const LiveRadioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveRadioControllerProvider);
    final controller = ref.read(liveRadioControllerProvider.notifier);
    final repository = InMemoryScheduleRepository();
    final now = DateTime.now();
    final program = repository.currentProgram(now);
    final upcoming = repository
        .programsFor(now)
        .where(
          (item) => item.start > Duration(hours: now.hour, minutes: now.minute),
        )
        .take(3);

    return CustomScrollView(
      key: const Key('live-radio-screen'),
      slivers: [
        SliverToBoxAdapter(
          child: _RadioHero(
            state: state,
            program: program,
            onToggle: controller.toggle,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
          sliver: SliverList.list(
            children: [
              const _SectionTitle(title: 'A seguir', action: 'Ver tudo'),
              const SizedBox(height: 12),
              if (upcoming.isEmpty)
                const _EmptyScheduleCard()
              else
                ...upcoming.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _ProgramCard(
                      time: item.formattedTime,
                      title: item.title,
                      subtitle: item.host,
                    ),
                  ),
                ),
              const SizedBox(height: 14),
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
  const _RadioHero({
    required this.state,
    required this.program,
    required this.onToggle,
  });

  final LiveRadioState state;
  final RadioProgram? program;
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
          colors: [Color(0xFFC6422F), SagresColors.red],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          child: Column(
            children: [
              const _StationHeader(),
              const SizedBox(height: 20),
              _AnimatedStationArtwork(isPlaying: isPlaying),
              const SizedBox(height: 18),
              const Text(
                'AGORA NO AR',
                style: TextStyle(
                  color: SagresColors.yellow,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                program?.title ?? 'Rádio Sagres ao vivo',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                program == null
                    ? 'Transmissão oficial · ${state.station.frequency}'
                    : '${program!.host} · ${program!.formattedTime}',
                style: const TextStyle(color: Color(0xFFFFD7CE), fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              _PlaybackControls(
                isPlaying: isPlaying,
                isLoading: isLoading,
                onToggle: onToggle,
              ),
              const SizedBox(height: 9),
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
              const SizedBox(height: 12),
              const _QuickActions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationHeader extends StatelessWidget {
  const _StationHeader();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SAGRES',
            style: TextStyle(
              color: SagresColors.yellow,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
            ),
          ),
          Text(
            'AM 730',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              height: .95,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      Spacer(),
      _RoundIcon(icon: Icons.cast, semanticLabel: 'Transmitir'),
    ],
  );
}

class _AnimatedStationArtwork extends StatefulWidget {
  const _AnimatedStationArtwork({required this.isPlaying});

  final bool isPlaying;

  @override
  State<_AnimatedStationArtwork> createState() =>
      _AnimatedStationArtworkState();
}

class _AnimatedStationArtworkState extends State<_AnimatedStationArtwork>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _AnimatedStationArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.isPlaying) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Center(
      child: Container(
        width: 230,
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: SagresColors.orange, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/sagres-cover.jpg', fit: BoxFit.cover),
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => CustomPaint(
                      key: Key(
                        widget.isPlaying
                            ? 'live-waves-playing'
                            : 'live-waves-paused',
                      ),
                      painter: _LiveWavePainter(
                        progress: _controller.value,
                        animate: widget.isPlaying,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(left: 10, bottom: 9, child: _LiveBadge()),
              Positioned(
                right: 11,
                bottom: 11,
                child: _Equalizer(
                  animation: _controller,
                  isPlaying: widget.isPlaying,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _LiveWavePainter extends CustomPainter {
  const _LiveWavePainter({required this.progress, required this.animate});

  final double progress;
  final bool animate;

  @override
  void paint(Canvas canvas, Size size) {
    final phase = animate ? progress * math.pi * 2 : 0.0;
    final baseY = size.height * .82;
    for (var wave = 0; wave < 2; wave++) {
      final path = Path()..moveTo(-20, baseY + wave * 10);
      for (double x = -20; x <= size.width + 20; x += 3) {
        final y =
            baseY +
            wave * 10 +
            math.sin((x / size.width * math.pi * 4) + phase + wave) * 5;
        path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = wave == 0 ? SagresColors.yellow : SagresColors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LiveWavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.animate != animate;
}

class _Equalizer extends StatelessWidget {
  const _Equalizer({required this.animation, required this.isPlaying});

  final Animation<double> animation;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (context, _) => Row(
      key: Key(isPlaying ? 'live-equalizer-playing' : 'live-equalizer-paused'),
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        final pulse = isPlaying
            ? (math.sin(animation.value * math.pi * 2 + index * .9) + 1) / 2
            : .35;
        return Container(
          width: 3,
          height: 8 + pulse * 15,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: SagresColors.yellow,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    ),
  );
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: SagresColors.yellow,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'AO VIVO',
      style: TextStyle(
        color: SagresColors.deepRed,
        fontSize: 10,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _PlaybackControls extends StatefulWidget {
  const _PlaybackControls({
    required this.isPlaying,
    required this.isLoading,
    required this.onToggle,
  });

  final bool isPlaying;
  final bool isLoading;
  final Future<void> Function() onToggle;

  @override
  State<_PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<_PlaybackControls>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );
    _syncGlow();
  }

  @override
  void didUpdateWidget(covariant _PlaybackControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) _syncGlow();
  }

  void _syncGlow() {
    if (widget.isPlaying) {
      _glowController.repeat(reverse: true);
    } else {
      _glowController.stop();
      _glowController.value = 0;
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const _DisabledControl(icon: Icons.skip_previous_rounded),
      const SizedBox(width: 28),
      AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) => Container(
          key: Key(
            widget.isPlaying ? 'play-button-animated' : 'play-button-static',
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: SagresColors.yellow.withValues(
                  alpha: widget.isPlaying
                      ? .25 + _glowController.value * .35
                      : .22,
                ),
                blurRadius: widget.isPlaying
                    ? 14 + _glowController.value * 18
                    : 12,
                spreadRadius: widget.isPlaying
                    ? 1 + _glowController.value * 4
                    : 0,
              ),
            ],
          ),
          child: child,
        ),
        child: Semantics(
          button: true,
          label: widget.isPlaying
              ? 'Pausar rádio ao vivo'
              : 'Ouvir rádio ao vivo',
          child: FilledButton(
            key: const Key('live-play-button'),
            onPressed: widget.isLoading ? null : widget.onToggle,
            style: FilledButton.styleFrom(
              shape: const CircleBorder(),
              fixedSize: const Size(72, 72),
              backgroundColor: SagresColors.yellow,
              disabledBackgroundColor: SagresColors.yellow.withValues(
                alpha: .75,
              ),
              foregroundColor: SagresColors.deepRed,
            ),
            child: widget.isLoading
                ? const SizedBox.square(
                    dimension: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: SagresColors.deepRed,
                    ),
                  )
                : Icon(
                    widget.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 39,
                  ),
          ),
        ),
      ),
      const SizedBox(width: 28),
      const _DisabledControl(icon: Icons.skip_next_rounded),
    ],
  );
}

class _DisabledControl extends StatelessWidget {
  const _DisabledControl({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Icon(
    icon,
    color: Colors.white70,
    size: 28,
    semanticLabel: 'Indisponível em transmissão ao vivo',
  );
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) => const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _RoundIcon(icon: Icons.favorite_border, semanticLabel: 'Favoritar'),
      SizedBox(width: 18),
      _RoundIcon(icon: Icons.share_outlined, semanticLabel: 'Compartilhar'),
      SizedBox(width: 18),
      _RoundIcon(icon: Icons.mic_none_rounded, semanticLabel: 'Microfone'),
    ],
  );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.semanticLabel});
  final IconData icon;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});
  final String title;
  final String action;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
      Text(
        action,
        style: const TextStyle(
          color: SagresColors.red,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.time,
    required this.title,
    required this.subtitle,
  });

  final String time;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF7EEE8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              time,
              style: const TextStyle(
                color: SagresColors.red,
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

class _EmptyScheduleCard extends StatelessWidget {
  const _EmptyScheduleCard();

  @override
  Widget build(BuildContext context) => const Card(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text('A grade demonstrativa de hoje foi encerrada.'),
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
