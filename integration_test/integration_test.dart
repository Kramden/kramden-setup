import 'package:flutter_test/flutter_test.dart';
import 'package:kramden_setup/main.dart' as app;
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  testWidgets('integration', (tester) async {
    await app.main();
    await tester.pumpAndSettle();

    final currentYear = DateTime.now().year.toString();

    expect(find.text('42'), findsOneWidget);
    expect(find.text(currentYear), findsNothing);

    await tester.tap(find.descendant(
      of: find.byType(YaruNavigationRailItem),
      matching: find.text('Year'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('42'), findsNothing);
    expect(find.text(currentYear), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(YaruNavigationRailItem),
      matching: find.text('Trivia'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('42'), findsOneWidget);
    expect(find.text(currentYear), findsNothing);
  });
}
