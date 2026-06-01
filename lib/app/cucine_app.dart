import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../features/city_search/presentation/widgets/search_body.dart';

/// Root dell'app: MaterialApp con il tema scuro del brand.
///
/// Per ora la home è la sola modalità ricerca. La navigazione-as-stato completa
/// (ricerca città → cucine) verrà introdotta nello step 10 con `HomeScreen`.
class CucineApp extends StatelessWidget {
  const CucineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cucine in città',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const _SearchHome(),
    );
  }
}

class _SearchHome extends StatelessWidget {
  const _SearchHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SearchBody(
        // Segnaposto temporaneo: nello step 10 il tap navigherà alle cucine.
        onCitySelected: (city) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Città selezionata: ${city.mainText}')),
            );
        },
      ),
    );
  }
}
