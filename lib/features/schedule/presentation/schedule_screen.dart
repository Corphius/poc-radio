import 'package:flutter/material.dart';

import '../../../app/theme/sagres_theme.dart';
import '../infrastructure/in_memory_schedule_repository.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  var _selectedDay = 0;
  static const _days = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];

  @override
  Widget build(BuildContext context) {
    final programs = InMemoryScheduleRepository().programsFor(DateTime.now());
    return SafeArea(
      child: CustomScrollView(
        key: const Key('schedule-screen'),
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 22, 20, 8),
            sliver: SliverToBoxAdapter(
              child: _ScreenHeading(
                icon: Icons.calendar_month,
                title: 'Programação',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 72,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => ChoiceChip(
                  key: Key('day-$index'),
                  label: Text(_days[index]),
                  selected: _selectedDay == index,
                  onSelected: (_) => setState(() => _selectedDay = index),
                  selectedColor: SagresColors.red,
                  labelStyle: TextStyle(
                    color: _selectedDay == index
                        ? Colors.white
                        : SagresColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                  side: BorderSide.none,
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Grade demonstrativa para validação da experiência.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList.separated(
              itemCount: programs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 9),
              itemBuilder: (context, index) {
                final program = programs[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: SagresColors.yellow.withValues(
                        alpha: .28,
                      ),
                      foregroundColor: SagresColors.red,
                      child: Text(
                        program.formattedTime,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    title: Text(
                      program.title,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text(program.host),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScreenHeading extends StatelessWidget {
  const _ScreenHeading({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      CircleAvatar(
        backgroundColor: SagresColors.yellow.withValues(alpha: .3),
        foregroundColor: SagresColors.red,
        child: Icon(icon),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
      ),
    ],
  );
}
