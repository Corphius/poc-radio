import 'package:flutter/material.dart';

import 'theme/sagres_theme.dart';
import '../features/shell/presentation/app_shell.dart';

class SagresApp extends StatelessWidget {
  const SagresApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Sagres AM 730',
    debugShowCheckedModeBanner: false,
    theme: SagresTheme.light,
    home: const AppShell(),
  );
}
