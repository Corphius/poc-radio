import 'package:flutter_test/flutter_test.dart';
import 'package:sagres_radio/features/schedule/infrastructure/in_memory_schedule_repository.dart';

void main() {
  final repository = InMemoryScheduleRepository();

  test('retorna programa correspondente ao horário atual', () {
    final current = repository.currentProgram(DateTime(2026, 7, 15, 10, 30));

    expect(current?.title, 'Debate Aberto');
    expect(current?.formattedTime, '10h');
  });

  test('não inventa programa antes do início da grade', () {
    expect(repository.currentProgram(DateTime(2026, 7, 15, 5, 59)), isNull);
  });

  test('retorna coleção imutável', () {
    final programs = repository.programsFor(DateTime(2026, 7, 15));

    expect(() => programs.clear(), throwsUnsupportedError);
  });
}
