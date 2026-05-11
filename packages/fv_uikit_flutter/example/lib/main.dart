import 'package:flutter/material.dart';

import 'routes/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<DocsLanguage> _language = ValueNotifier(DocsLanguage.en);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _language.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return DocsLanguageScope(
      notifier: _language,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const DocsHomeScreen(),
        routes: {
          '/tokens_screen': (context) => const TokensScreen(),
          '/texts_screen': (context) => const TextScreen(),
          '/loading_screen': (context) => const LoadingScreen(),
          '/skeletons_screen': (context) => const SkeletonsScreen(),
          '/buttons_screen': (context) => ButtonsScreen(),
          '/checkboxes_screen': (context) => const CheckboxesScreen(),
          '/dividers_screen': (context) => const DividersScreen(),
          '/labels_screen': (context) => const LabelsScreen(),
          '/alerts_screen': (context) => const AlertsScreen(),
          '/bottom_sheets_screen': (context) => const BottomSheetsScreen(),
          '/bottom_sheet_selects_screen':
              (context) => const BottomSheetSelectsScreen(),
          '/text_fields_screen': (context) => TextFieldsScreen(),
          '/otp_fields_screen': (context) => const OtpFieldsScreen(),
          '/date_time_fields_screen': (context) => const DateTimeFieldsScreen(),
          '/dropdowns_screen': (context) => const DropdownsScreen(),
          '/modals_screen': (context) => const ModalsScreen(),
          '/switches_screen': (context) => const SwitchesScreen(),
          '/radios_screen': (context) => const RadiosScreen(),
        },
      ),
    );
  }
}
