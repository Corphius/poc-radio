import '../domain/entities/radio_program.dart';
import '../domain/ports/schedule_repository.dart';

class InMemoryScheduleRepository implements ScheduleRepository {
  static const _programs = [
    RadioProgram(
      start: Duration(hours: 6),
      title: 'Bom Dia Goiás',
      host: 'Programação demonstrativa',
    ),
    RadioProgram(
      start: Duration(hours: 9),
      title: 'Sagres Notícias',
      host: 'Programação demonstrativa',
    ),
    RadioProgram(
      start: Duration(hours: 10),
      title: 'Debate Aberto',
      host: 'Programação demonstrativa',
    ),
    RadioProgram(
      start: Duration(hours: 12),
      title: 'Almoço com Música',
      host: 'Programação demonstrativa',
    ),
    RadioProgram(
      start: Duration(hours: 14),
      title: 'Tarde em Tom Maior',
      host: 'Programação demonstrativa',
    ),
    RadioProgram(
      start: Duration(hours: 18),
      title: 'Jornal da Sagres',
      host: 'Programação demonstrativa',
    ),
  ];

  @override
  List<RadioProgram> programsFor(DateTime date) => List.unmodifiable(_programs);

  @override
  RadioProgram? currentProgram(DateTime instant) {
    final elapsed = Duration(hours: instant.hour, minutes: instant.minute);
    RadioProgram? current;
    for (final program in _programs) {
      if (program.start <= elapsed) current = program;
    }
    return current;
  }
}
