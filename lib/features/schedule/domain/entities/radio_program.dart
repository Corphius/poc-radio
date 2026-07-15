class RadioProgram {
  const RadioProgram({
    required this.start,
    required this.title,
    required this.host,
  });

  final Duration start;
  final String title;
  final String host;

  String get formattedTime => '${start.inHours.toString().padLeft(2, '0')}h';
}
