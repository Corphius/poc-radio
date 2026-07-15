class LiveStation {
  const LiveStation({
    required this.name,
    required this.frequency,
    required this.streamUrl,
    required this.tagline,
  });

  final String name;
  final String frequency;
  final Uri streamUrl;
  final String tagline;

  static final sagres = LiveStation(
    name: 'Sagres',
    frequency: 'AM 730',
    streamUrl: Uri.parse('https://cast4.audiostream.com.br:20010/stream'),
    tagline: 'em tom maior',
  );
}
