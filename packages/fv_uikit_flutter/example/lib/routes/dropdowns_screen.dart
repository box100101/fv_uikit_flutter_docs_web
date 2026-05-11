import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class DropdownsScreen extends StatefulWidget {
  const DropdownsScreen({super.key});

  @override
  State<DropdownsScreen> createState() => _DropdownsScreenState();
}

class _DropdownsScreenState extends State<DropdownsScreen> {
  String? _selectedDropdownSizeXSmall;
  String? _selectedDropdownSizeSmall;
  String? _selectedDropdownSizeMedium;
  String? _selectedDropdownSizeLarge;
  String? _selectedDropdownSizeXLarge;
  String? _selectedDropdownDisabled;
  String? _selectedDropdownWithLabel;

  final itemsOfTypeString = const [
    'option 1',
    'option 2',
    'option 3',
    'option 4',
    'option 5',
    'option 6',
  ];

  final itemsOfTypeObject = const [
    {'id': 1, 'name': 'option 1'},
    {'id': 2, 'name': 'option 2'},
    {'id': 3, 'name': 'option 3'},
    {'id': 4, 'name': 'option 4'},
    {'id': 5, 'name': 'option 5'},
    {'id': 6, 'name': 'option 6'},
  ];

  @override
  Widget build(BuildContext context) {
    final dropdowns = [
      AppDropdown<String>(
        hintText: 'Choose an option (xSmall)',
        items: itemsOfTypeString,
        value: _selectedDropdownSizeXSmall,
        onChanged:
            (value) => {setState(() => _selectedDropdownSizeXSmall = value)},
        itemAsString: (item) => item,
        size: AppDropdownSize.xSmall,
        isSearchable: true,
      ),
      AppDropdown<String>(
        hintText: 'Choose an option (small)',
        items: itemsOfTypeString,
        value: _selectedDropdownSizeSmall,
        onChanged:
            (value) => {setState(() => _selectedDropdownSizeSmall = value)},
        itemAsString: (item) => item,
        size: AppDropdownSize.small,
        isSearchable: true,
      ),
      AppDropdown<String>(
        hintText: 'Choose an option (medium)',
        items: itemsOfTypeString,
        value: _selectedDropdownSizeMedium,
        onChanged:
            (value) => {setState(() => _selectedDropdownSizeMedium = value)},
        itemAsString: (item) => item,
        size: AppDropdownSize.medium,
        isSearchable: true,
      ),
      AppDropdown<String>(
        hintText: 'Choose an option (large)',
        items: itemsOfTypeString,
        value: _selectedDropdownSizeLarge,
        onChanged:
            (value) => {setState(() => _selectedDropdownSizeLarge = value)},
        itemAsString: (item) => item,
        size: AppDropdownSize.large,
        isSearchable: true,
        menuMaxHeight: 250,
      ),
      AppDropdown<String>(
        hintText: 'Choose an option (xLarge)',
        items: itemsOfTypeString,
        value: _selectedDropdownSizeXLarge,
        onChanged:
            (value) => {setState(() => _selectedDropdownSizeXLarge = value)},
        itemAsString: (item) => item,
        size: AppDropdownSize.xLarge,
        isSearchable: true,
        menuMaxHeight: 300,
      ),
      AppDropdown<String>(
        labelText: 'Label text',
        hintText: 'Choose an option',
        items: itemsOfTypeString,
        value: _selectedDropdownWithLabel,
        onChanged:
            (value) => {setState(() => _selectedDropdownWithLabel = value)},
        itemAsString: (item) => item,
        isSearchable: true,
      ),
      AppDropdown<String>(
        hintText: 'Choose an option (disabled)',
        items: itemsOfTypeString,
        value: _selectedDropdownDisabled,
        onChanged:
            (value) => {setState(() => _selectedDropdownDisabled = value)},
        itemAsString: (item) => item,
        isSearchable: true,
        isDisabled: true,
      ),
    ];

    return DocsScaffold(
      title: const DocsText(en: 'Dropdowns', vi: 'Dropdowns'),
      description: const DocsText(
        en:
            'Selectable menus for string or object data, with search and remote-loading support.',
        vi:
            'Menu lựa chọn cho dữ liệu string hoặc object, hỗ trợ search và remote-loading.',
      ),
      doc: widgetDocFor('dropdown'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < dropdowns.length; index++) ...[
                dropdowns[index],
                if (index != dropdowns.length - 1)
                  const SizedBox(height: SpacingTokens.paddingM),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
