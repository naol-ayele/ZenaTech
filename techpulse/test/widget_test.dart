import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techpulse/l10n/app_localizations.dart';
import 'package:techpulse/presentation/widgets/empty_state_widget.dart';

Widget wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EmptyStateWidget(title: 'Nothing here', subtitle: 'Try later'),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Try later'), findsOneWidget);
    });

    testWidgets('renders title without subtitle', (tester) async {
      await tester.pumpWidget(
        wrap(const EmptyStateWidget(title: 'Only title')),
      );

      expect(find.text('Only title'), findsOneWidget);
    });

    testWidgets('shows default icon when no action provided', (tester) async {
      await tester.pumpWidget(
        wrap(const EmptyStateWidget(title: 'Empty')),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('renders custom action widget', (tester) async {
      await tester.pumpWidget(
        wrap(
          const EmptyStateWidget(
            title: 'Empty',
            action: Icon(Icons.star),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsNothing);
    });

    testWidgets('favorites factory renders localized strings', (tester) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => EmptyStateWidget.favorites(context))),
      );

      expect(find.byIcon(Icons.favorite_outline), findsWidgets);
    });

    testWidgets('search factory renders search icon', (tester) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => EmptyStateWidget.search(context))),
      );

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('articles factory renders article icon', (tester) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => EmptyStateWidget.articles(context))),
      );

      expect(find.byIcon(Icons.article_outlined), findsOneWidget);
    });

    testWidgets('category factory renders folder icon', (tester) async {
      await tester.pumpWidget(
        wrap(Builder(builder: (context) => EmptyStateWidget.category(context))),
      );

      expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
    });
  });
}
