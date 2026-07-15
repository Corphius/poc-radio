import '../entities/radio_program.dart';

abstract interface class ScheduleRepository {
  List<RadioProgram> programsFor(DateTime date);
  RadioProgram? currentProgram(DateTime instant);
}
