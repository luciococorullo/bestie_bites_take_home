import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'home_screen.dart';

/// Root dell'app: MaterialApp con il tema scuro del brand.
///
/// La home è [HomeScreen], che gestisce la navigazione-as-stato (ricerca città
/// ↔ cucine) tramite l'`AppViewController`.
class CucineApp extends StatelessWidget {
  const CucineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cucine in città',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
