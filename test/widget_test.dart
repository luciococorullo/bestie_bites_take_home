import 'package:bestie_bites_take_home/app/cucine_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CucineApp si avvia e mostra il titolo', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CucineApp()));

    expect(find.text('Cucine in città'), findsOneWidget);
  });
}
