import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

void main() {
  testWidgets('AppTablePaginationBar renders and handles navigation', (WidgetTester tester) async {
    int pageGoTo = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 2,
            totalPages: 5,
            total: 50,
            startRecord: 11,
            endRecord: 20,
            pageSize: 10,
            onGoToPage: (page) {
              pageGoTo = page;
            },
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    // Alignment is TextAlign.start
    final textFinder = find.text('Từ 11-20 trên tổng 50');
    expect(textFinder, findsOneWidget);
    final appTextWidget = tester.widget<AppText>(
      find.ancestor(of: textFinder, matching: find.byType(AppText)),
    );
    expect(appTextWidget.textAlign, TextAlign.start);

    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('3'));
    await tester.pump();

    expect(pageGoTo, 3);
  });

  testWidgets('AppTablePaginationBar disables navigation buttons at boundaries', (WidgetTester tester) async {
    int pageGoTo = 0;

    // Boundary at Page 1
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 1,
            totalPages: 5,
            total: 50,
            startRecord: 1,
            endRecord: 10,
            pageSize: 10,
            onGoToPage: (page) {
              pageGoTo = page;
            },
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    final prevIconFinder = find.byIcon(Icons.chevron_left);
    final nextIconFinder = find.byIcon(Icons.chevron_right);

    // Left chevron is disabled
    final prevIconButton = tester.widget<IconButton>(
      find.ancestor(of: prevIconFinder, matching: find.byType(IconButton)),
    );
    expect(prevIconButton.onPressed, isNull);

    // Right chevron is enabled
    final nextIconButton = tester.widget<IconButton>(
      find.ancestor(of: nextIconFinder, matching: find.byType(IconButton)),
    );
    expect(nextIconButton.onPressed, isNotNull);

    await tester.tap(nextIconFinder);
    await tester.pump();
    expect(pageGoTo, 2);

    // Boundary at Page 5 (last page)
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 5,
            totalPages: 5,
            total: 50,
            startRecord: 41,
            endRecord: 50,
            pageSize: 10,
            onGoToPage: (page) {
              pageGoTo = page;
            },
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    // Left chevron is enabled
    final prevIconButtonLast = tester.widget<IconButton>(
      find.ancestor(of: prevIconFinder, matching: find.byType(IconButton)),
    );
    expect(prevIconButtonLast.onPressed, isNotNull);

    // Right chevron is disabled
    final nextIconButtonLast = tester.widget<IconButton>(
      find.ancestor(of: nextIconFinder, matching: find.byType(IconButton)),
    );
    expect(nextIconButtonLast.onPressed, isNull);

    await tester.tap(prevIconFinder);
    await tester.pump();
    expect(pageGoTo, 4);
  });

  testWidgets('AppTablePaginationBar renders ellipses when totalPages is large', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 5,
            totalPages: 10,
            total: 100,
            startRecord: 41,
            endRecord: 50,
            pageSize: 10,
            onGoToPage: (page) {},
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    // With currentPage: 5, totalPages: 10, page list is 1, ..., 4, 5, 6, ..., 10
    expect(find.text('...'), findsNWidgets(2));
    expect(find.text('1'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('AppTablePaginationBar supports customized labels/localization', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 2,
            totalPages: 5,
            total: 50,
            startRecord: 11,
            endRecord: 20,
            pageSize: 10,
            recordTextBuilder: (start, end, total) => 'Showing $start-$end of $total entries',
            pageSizeLabelBuilder: (size) => '$size per page',
            onGoToPage: (page) {},
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    expect(find.text('Showing 11-20 of 50 entries'), findsOneWidget);
    expect(find.text('10 per page'), findsOneWidget);
  });

  testWidgets('AppTablePaginationBar handles PageSize Dropdown interaction', (WidgetTester tester) async {
    int sizeChange = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 2,
            totalPages: 5,
            total: 50,
            startRecord: 11,
            endRecord: 20,
            pageSize: 10,
            onGoToPage: (page) {},
            onChangePageSize: (size) {
              sizeChange = size;
            },
          ),
        ),
      ),
    );

    // Open dropdown
    await tester.tap(find.text('10 / trang'));
    await tester.pumpAndSettle();

    // Select 20 from dropdown list
    await tester.tap(find.text('20 / trang').last);
    await tester.pumpAndSettle();

    expect(sizeChange, 20);
  });

  testWidgets('AppTablePaginationBar handles Jump dialog interaction', (WidgetTester tester) async {
    int pageGoTo = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTablePaginationBar(
            currentPage: 2,
            totalPages: 5,
            total: 50,
            startRecord: 11,
            endRecord: 20,
            pageSize: 10,
            hasJumpButton: true,
            jumpToPageLabel: 'Go to Page',
            cancelLabel: 'Cancel',
            goLabel: 'Go',
            onGoToPage: (page) {
              pageGoTo = page;
            },
            onChangePageSize: (size) {},
          ),
        ),
      ),
    );

    final jumpBtnFinder = find.byIcon(Icons.more_horiz);
    expect(jumpBtnFinder, findsOneWidget);

    await tester.tap(jumpBtnFinder);
    await tester.pumpAndSettle();

    // Dialog should be open with custom labels
    expect(find.text('Go to Page'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);

    // Input target page and submit
    await tester.enterText(find.byType(TextField), '4');
    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    expect(pageGoTo, 4);
  });
}
