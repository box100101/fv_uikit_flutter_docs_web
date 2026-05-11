import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class BottomSheetSelectsScreen extends StatefulWidget {
  const BottomSheetSelectsScreen({super.key});

  @override
  State<BottomSheetSelectsScreen> createState() =>
      _BottomSheetSelectsScreenState();
}

class _BottomSheetSelectsScreenState extends State<BottomSheetSelectsScreen> {
  static const _pageSize = 10;

  final List<String> _singleChoiceOptions = const [
    'Option A',
    'Option B',
    'Option C',
  ];

  final List<String> _multiChoiceOptions = const [
    'Tag 1',
    'Tag 2',
    'Tag 3',
    'Tag 4',
  ];

  final List<_RemoteOption> _allRemoteOptions = List.generate(
    32,
    (index) => _RemoteOption(
      id: index + 1,
      title: 'Remote option ${index + 1}',
      description: 'Supporting description for option ${index + 1}.',
    ),
  );

  String? _selectedSingleChoice;
  List<String> _selectedMultiChoices = const ['Tag 2'];
  _RemoteOption? _selectedRemoteOption;
  List<_RemoteOption> _remoteOptions = <_RemoteOption>[];
  bool _isLoadingRemoteOptions = false;
  bool _isLoadingMoreRemoteOptions = false;
  bool _hasMoreRemoteOptions = true;
  String _remoteQuery = '';

  @override
  void initState() {
    super.initState();
    unawaited(_fetchRemoteOptions(reset: true));
  }

  Future<void> _fetchRemoteOptions({required bool reset, String? query}) async {
    final nextQuery = query ?? _remoteQuery;
    final normalizedQuery = nextQuery.trim().toLowerCase();

    setState(() {
      _remoteQuery = nextQuery;
      if (reset) {
        _isLoadingRemoteOptions = true;
      } else {
        _isLoadingMoreRemoteOptions = true;
      }
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));

    final filteredItems =
        _allRemoteOptions.where((item) {
          final titleMatches = item.title.toLowerCase().contains(
            normalizedQuery,
          );
          final descriptionMatches = item.description.toLowerCase().contains(
            normalizedQuery,
          );

          return titleMatches || descriptionMatches;
        }).toList();

    final currentLength = reset ? 0 : _remoteOptions.length;
    final end = (currentLength + _pageSize).clamp(0, filteredItems.length);
    final nextItems = filteredItems.take(end).toList();

    if (!mounted) return;

    setState(() {
      _remoteOptions = nextItems;
      _isLoadingRemoteOptions = false;
      _isLoadingMoreRemoteOptions = false;
      _hasMoreRemoteOptions = nextItems.length < filteredItems.length;
    });
  }

  String _selectedTagsText(List<String> values) {
    if (values.isEmpty) return '';
    if (values.length <= 2) {
      return values.join(', ');
    }

    return '${values.length} items selected';
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(
        en: 'Bottom Sheet Select',
        vi: 'Bottom Sheet Select',
      ),
      description: const DocsText(
        en:
            'Selectable fields that open an AppBottomSheet, with local search, remote search, and multi-choice support.',
        vi:
            'Field chọn mở bằng AppBottomSheet, hỗ trợ local search, remote search và multi-choice.',
      ),
      doc: widgetDocFor('bottomSheetSelect'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppBottomSheetSelect<String>.single(
                labelText: 'Single choice',
                hintText: 'Choose one option',
                helperText: 'Generic example for one selected item.',
                items: _singleChoiceOptions,
                value: _selectedSingleChoice,
                itemAsString: (item) => item,
                onChanged:
                    (value) => setState(() => _selectedSingleChoice = value),
                isSearchable: true,
                sheetTitle: 'Single choice',
              ),
              const SizedBox(height: SpacingTokens.paddingL),
              AppBottomSheetSelect<String>.multi(
                labelText: 'Multi choice',
                hintText: 'Choose multiple options',
                items: _multiChoiceOptions,
                values: _selectedMultiChoices,
                itemAsString: (item) => item,
                selectedItemsTextBuilder: _selectedTagsText,
                onChanged:
                    (values) => setState(() => _selectedMultiChoices = values),
                sheetTitle: 'Multi choice',
              ),
              const SizedBox(height: SpacingTokens.paddingL),
              AppBottomSheetSelect<_RemoteOption>.single(
                labelText: 'Remote search',
                hintText: 'Search and choose one option',
                isRequired: true,
                items: _remoteOptions,
                value: _selectedRemoteOption,
                itemAsString: (item) => item.title,
                itemDescriptionAsString: (item) => item.description,
                onChanged:
                    (value) => setState(() => _selectedRemoteOption = value),
                isSearchable: true,
                enableLocalFilter: false,
                isLoading: _isLoadingRemoteOptions,
                isLoadingMore: _isLoadingMoreRemoteOptions,
                hasMore: _hasMoreRemoteOptions,
                onSearchChanged:
                    (keyword) =>
                        _fetchRemoteOptions(reset: true, query: keyword),
                onLoadMore: () => _fetchRemoteOptions(reset: false),
                onRetry: () => _fetchRemoteOptions(reset: true),
                sheetTitle: 'Remote search',
                sheetDescription:
                    'Generic example for remote search and pagination.',
              ),
              const SizedBox(height: SpacingTokens.paddingL),
              AppBottomSheetSelect<String>.single(
                labelText: 'Disabled state',
                hintText: 'This field is disabled',
                items: _singleChoiceOptions,
                value: 'Option B',
                itemAsString: (item) => item,
                onChanged: (_) {},
                isDisabled: true,
                sheetTitle: 'Disabled state',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RemoteOption {
  final int id;
  final String title;
  final String description;

  const _RemoteOption({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) {
    return other is _RemoteOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
