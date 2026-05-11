import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

enum DocsLanguage { en, vi }

class DocsText {
  final String en;
  final String vi;

  const DocsText({required this.en, required this.vi});

  String resolve(DocsLanguage language) {
    return switch (language) {
      DocsLanguage.en => en,
      DocsLanguage.vi => vi,
    };
  }
}

class DocsLanguageScope extends InheritedNotifier<ValueNotifier<DocsLanguage>> {
  const DocsLanguageScope({
    super.key,
    required ValueNotifier<DocsLanguage> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ValueNotifier<DocsLanguage> controllerOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<DocsLanguageScope>();
    return scope?.notifier ?? _fallbackLanguageController;
  }

  static DocsLanguage languageOf(BuildContext context) {
    return controllerOf(context).value;
  }

  static final ValueNotifier<DocsLanguage> _fallbackLanguageController =
      ValueNotifier(DocsLanguage.en);
}

class DocsLanguageSwitch extends StatelessWidget {
  const DocsLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DocsLanguageScope.controllerOf(context);

    return ValueListenableBuilder<DocsLanguage>(
      valueListenable: controller,
      builder: (context, language, _) {
        return SegmentedButton<DocsLanguage>(
          segments: const [
            ButtonSegment(value: DocsLanguage.en, label: Text('EN')),
            ButtonSegment(value: DocsLanguage.vi, label: Text('VI')),
          ],
          selected: {language},
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ColorTokens.primaryDefault;
              }
              return ColorTokens.textDefault;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ColorTokens.primaryBg;
              }
              return ColorTokens.white;
            }),
          ),
          onSelectionChanged: (selection) {
            controller.value = selection.first;
          },
        );
      },
    );
  }
}

class DocsScaffold extends StatelessWidget {
  final DocsText title;
  final DocsText description;
  final WidgetDoc? doc;
  final List<Widget> children;

  const DocsScaffold({
    super.key,
    required this.title,
    required this.description,
    this.doc,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final resolvedDoc = doc;

    return Scaffold(
      backgroundColor: ColorTokens.backgroundColorExample,
      appBar: DocsAppBar(title: title.resolve(language)),
      body: ListView(
        padding: const EdgeInsets.all(SpacingTokens.paddingM),
        children: [
          _PageHeader(title: title, description: description),
          if (resolvedDoc != null) ...[
            const SizedBox(height: SpacingTokens.gapM),
            WidgetDocPanel(doc: resolvedDoc),
          ],
          const SizedBox(height: SpacingTokens.gapL),
          ...children,
        ],
      ),
    );
  }
}

class DocsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DocsAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AppText(
        text: title,
        color: ColorTokens.white,
        size: AppTextSize.heading4Bold,
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: SpacingTokens.paddingM),
          child: Center(child: DocsLanguageSwitch()),
        ),
      ],
      backgroundColor: ColorTokens.primary,
      iconTheme: const IconThemeData(color: ColorTokens.white),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final DocsText title;
  final DocsText description;

  const _PageHeader({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title.resolve(language),
            size: AppTextSize.heading4Bold,
            color: ColorTokens.textDefault,
          ),
          const SizedBox(height: SpacingTokens.gapS),
          AppText(
            text: description.resolve(language),
            size: AppTextSize.bodyMRegular,
            color: ColorTokens.textDescription,
          ),
        ],
      ),
    );
  }
}

class WidgetDoc {
  final DocsText title;
  final DocsText description;
  final DocsText quickUse;
  final List<PropDoc> props;

  const WidgetDoc({
    required this.title,
    required this.description,
    required this.quickUse,
    required this.props,
  });
}

class PropDoc {
  final String name;
  final String type;
  final bool required;
  final String defaultValue;
  final DocsText description;

  const PropDoc({
    required this.name,
    required this.type,
    this.required = false,
    this.defaultValue = '-',
    required this.description,
  });
}

class WidgetDocPanel extends StatelessWidget {
  final WidgetDoc doc;

  const WidgetDocPanel({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final labels = _DocsLabels(language);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: labels.usageGuide),
          AppText(
            text: doc.description.resolve(language),
            size: AppTextSize.bodyMRegular,
            color: ColorTokens.textDescription,
          ),
          const SizedBox(height: SpacingTokens.gapM),
          _CodeBlock(code: doc.quickUse.resolve(language)),
          const SizedBox(height: SpacingTokens.gapL),
          _SectionTitle(text: labels.propsTable),
          PropsTable(props: doc.props),
        ],
      ),
    );
  }
}

class PropsTable extends StatelessWidget {
  final List<PropDoc> props;

  const PropsTable({super.key, required this.props});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final labels = _DocsLabels(language);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(ColorTokens.fillTertiary),
        headingTextStyle: const TextStyle(
          color: ColorTokens.textDefault,
          fontWeight: FontWeight.w700,
        ),
        columns: [
          DataColumn(label: Text(labels.prop)),
          DataColumn(label: Text(labels.type)),
          DataColumn(label: Text(labels.required)),
          DataColumn(label: Text(labels.defaultValue)),
          DataColumn(label: Text(labels.note)),
        ],
        rows:
            props
                .map(
                  (prop) => DataRow(
                    cells: [
                      DataCell(Text(prop.name)),
                      DataCell(Text(prop.type)),
                      DataCell(Text(prop.required ? labels.yes : labels.no)),
                      DataCell(Text(prop.defaultValue)),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Text(prop.description.resolve(language)),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}

class ExampleSection extends StatelessWidget {
  final DocsText title;
  final DocsText? description;
  final Widget child;

  const ExampleSection({
    super.key,
    required this.title,
    this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final resolvedDescription = description?.resolve(language);

    return _SurfacePanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: title.resolve(language)),
          if (resolvedDescription != null) ...[
            const SizedBox(height: SpacingTokens.gapXS),
            AppText(
              text: resolvedDescription,
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDescription,
            ),
            const SizedBox(height: SpacingTokens.gapM),
          ],
          child,
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;

  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final labels = _DocsLabels(language);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF101820),
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SpacingTokens.paddingM,
              SpacingTokens.paddingS,
              SpacingTokens.paddingS,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    labels.quickUse,
                    style: const TextStyle(
                      color: ColorTokens.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: labels.copyCode,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(labels.copied)));
                  },
                  icon: const Icon(Icons.copy, color: ColorTokens.white),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(SpacingTokens.paddingM),
            child: SelectableText(
              code,
              style: const TextStyle(
                color: Color(0xFFE6EDF3),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurfacePanel extends StatelessWidget {
  final Widget child;

  const _SurfacePanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
        boxShadow: BoxShadowTokens.boxShadowTertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingL),
        child: child,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppText(
      text: text,
      size: AppTextSize.bodyLBold,
      color: ColorTokens.textDefault,
    );
  }
}

class _DocsLabels {
  final DocsLanguage language;

  const _DocsLabels(this.language);

  String get usageGuide => switch (language) {
    DocsLanguage.en => 'Usage guide',
    DocsLanguage.vi => 'Hướng dẫn sử dụng',
  };

  String get propsTable => switch (language) {
    DocsLanguage.en => 'Props reference',
    DocsLanguage.vi => 'Bảng chú thích props',
  };

  String get quickUse => switch (language) {
    DocsLanguage.en => 'Quick copy-paste',
    DocsLanguage.vi => 'Dùng nhanh copy-paste',
  };

  String get copyCode => switch (language) {
    DocsLanguage.en => 'Copy code',
    DocsLanguage.vi => 'Sao chép code',
  };

  String get copied => switch (language) {
    DocsLanguage.en => 'Code copied',
    DocsLanguage.vi => 'Đã sao chép code',
  };

  String get prop => switch (language) {
    DocsLanguage.en => 'Prop',
    DocsLanguage.vi => 'Prop',
  };

  String get type => switch (language) {
    DocsLanguage.en => 'Type',
    DocsLanguage.vi => 'Kiểu',
  };

  String get required => switch (language) {
    DocsLanguage.en => 'Required',
    DocsLanguage.vi => 'Bắt buộc',
  };

  String get defaultValue => switch (language) {
    DocsLanguage.en => 'Default',
    DocsLanguage.vi => 'Mặc định',
  };

  String get note => switch (language) {
    DocsLanguage.en => 'Note',
    DocsLanguage.vi => 'Ghi chú',
  };

  String get yes => switch (language) {
    DocsLanguage.en => 'Yes',
    DocsLanguage.vi => 'Có',
  };

  String get no => switch (language) {
    DocsLanguage.en => 'No',
    DocsLanguage.vi => 'Không',
  };
}

class DocsHomeScreen extends StatelessWidget {
  const DocsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return Scaffold(
      backgroundColor: ColorTokens.backgroundColorExample,
      appBar: DocsAppBar(
        title: const DocsText(
          en: 'FV UIKit Catalog',
          vi: 'Danh mục FV UIKit',
        ).resolve(language),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SpacingTokens.paddingM),
        children: [
          _PageHeader(
            title: const DocsText(
              en: 'FV UIKit Catalog',
              vi: 'Danh mục FV UIKit',
            ),
            description: const DocsText(
              en:
                  'Explore tokens, ready-made widgets, usage snippets, and prop notes before integrating the package into another project.',
              vi:
                  'Tra cứu tokens, widget build sẵn, snippet sử dụng và ghi chú props trước khi tích hợp package vào dự án khác.',
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          for (final group in _catalogGroups) ...[
            ExampleSection(
              title: group.title,
              description: group.description,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  final width =
                      isWide
                          ? (constraints.maxWidth - SpacingTokens.gapM) / 2
                          : constraints.maxWidth;

                  return Wrap(
                    spacing: SpacingTokens.gapM,
                    runSpacing: SpacingTokens.gapM,
                    children:
                        group.items
                            .map(
                              (item) => SizedBox(
                                width: width,
                                child: _CatalogTile(item: item),
                              ),
                            )
                            .toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: SpacingTokens.gapL),
          ],
        ],
      ),
    );
  }
}

class _CatalogGroup {
  final DocsText title;
  final DocsText description;
  final List<_CatalogItem> items;

  const _CatalogGroup({
    required this.title,
    required this.description,
    required this.items,
  });
}

class _CatalogItem {
  final DocsText title;
  final DocsText description;
  final String routeName;
  final IconData icon;

  const _CatalogItem({
    required this.title,
    required this.description,
    required this.routeName,
    required this.icon,
  });
}

class _CatalogTile extends StatelessWidget {
  final _CatalogItem item;

  const _CatalogTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      onTap: () => Navigator.pushNamed(context, item.routeName),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
          border: Border.all(color: ColorTokens.borderDefault),
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.paddingM),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorTokens.primaryBg,
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
                ),
                child: Icon(item.icon, color: ColorTokens.primaryDefault),
              ),
              const SizedBox(width: SpacingTokens.gapM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: item.title.resolve(language),
                      size: AppTextSize.bodyMBold,
                      color: ColorTokens.textDefault,
                    ),
                    const SizedBox(height: SpacingTokens.gapXS),
                    AppText(
                      text: item.description.resolve(language),
                      size: AppTextSize.bodySRegular,
                      color: ColorTokens.textDescription,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ColorTokens.iconDefault),
            ],
          ),
        ),
      ),
    );
  }
}

const List<_CatalogGroup> _catalogGroups = [
  _CatalogGroup(
    title: DocsText(en: 'Foundations', vi: 'Nền tảng'),
    description: DocsText(
      en: 'Design tokens used by every component.',
      vi: 'Các design token được dùng xuyên suốt component.',
    ),
    items: [
      _CatalogItem(
        title: DocsText(en: 'Tokens', vi: 'Tokens'),
        description: DocsText(
          en: 'Color, spacing, radius, typography, size, shadow, breakpoint.',
          vi: 'Color, spacing, radius, typography, size, shadow, breakpoint.',
        ),
        routeName: '/tokens_screen',
        icon: Icons.palette_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Text', vi: 'Text'),
        description: DocsText(
          en: 'Typography atom with semantic text styles.',
          vi: 'Atom hiển thị chữ với các text style theo hệ thống.',
        ),
        routeName: '/texts_screen',
        icon: Icons.text_fields,
      ),
      _CatalogItem(
        title: DocsText(en: 'Divider', vi: 'Divider'),
        description: DocsText(
          en: 'Horizontal and vertical separators.',
          vi: 'Đường phân tách ngang và dọc.',
        ),
        routeName: '/dividers_screen',
        icon: Icons.horizontal_rule,
      ),
      _CatalogItem(
        title: DocsText(en: 'Label', vi: 'Label'),
        description: DocsText(
          en: 'Form labels with required, optional, and info states.',
          vi: 'Nhãn form với trạng thái bắt buộc, tùy chọn và info.',
        ),
        routeName: '/labels_screen',
        icon: Icons.label_outline,
      ),
      _CatalogItem(
        title: DocsText(en: 'Loading', vi: 'Loading'),
        description: DocsText(
          en: 'Reusable spinner for inline, section, and async loading states.',
          vi:
              'Spinner tái sử dụng cho loading inline, theo section và trạng thái async.',
        ),
        routeName: '/loading_screen',
        icon: Icons.autorenew,
      ),
      _CatalogItem(
        title: DocsText(en: 'Skeleton', vi: 'Skeleton'),
        description: DocsText(
          en: 'Shimmer placeholders for loading text, lists, and cards.',
          vi: 'Placeholder shimmer cho text, danh sách và card lúc loading.',
        ),
        routeName: '/skeletons_screen',
        icon: Icons.view_agenda_outlined,
      ),
    ],
  ),
  _CatalogGroup(
    title: DocsText(en: 'Inputs', vi: 'Nhập liệu'),
    description: DocsText(
      en: 'Form controls for collecting user input.',
      vi: 'Các điều khiển form để thu thập dữ liệu người dùng.',
    ),
    items: [
      _CatalogItem(
        title: DocsText(en: 'Button', vi: 'Button'),
        description: DocsText(
          en: 'Actions with variants, sizes, icons, loading, disabled.',
          vi: 'Nút hành động với variant, size, icon, loading, disabled.',
        ),
        routeName: '/buttons_screen',
        icon: Icons.smart_button_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Text Field', vi: 'Text Field'),
        description: DocsText(
          en: 'Text input, search, validation, prefix and suffix slots.',
          vi: 'Nhập text, search, validate, slot prefix và suffix.',
        ),
        routeName: '/text_fields_screen',
        icon: Icons.input,
      ),
      _CatalogItem(
        title: DocsText(en: 'OTP Field', vi: 'OTP Field'),
        description: DocsText(
          en: 'Separated OTP digits with paste support and complete callback.',
          vi: 'Ô OTP tách digit, hỗ trợ paste và callback khi nhập đủ mã.',
        ),
        routeName: '/otp_fields_screen',
        icon: Icons.password_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Date Time Field', vi: 'Date Time Field'),
        description: DocsText(
          en: 'Date, time, date-time pickers and custom formatting.',
          vi: 'Picker ngày, giờ, ngày-giờ và tùy biến format.',
        ),
        routeName: '/date_time_fields_screen',
        icon: Icons.event_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Dropdown', vi: 'Dropdown'),
        description: DocsText(
          en: 'Selectable lists with search, empty, loading, error states.',
          vi: 'Danh sách chọn với search, empty, loading, error.',
        ),
        routeName: '/dropdowns_screen',
        icon: Icons.arrow_drop_down_circle_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Bottom Sheet Select', vi: 'Bottom Sheet Select'),
        description: DocsText(
          en: 'Select field using AppBottomSheet with single or multi choice.',
          vi: 'Field chọn dùng AppBottomSheet với single hoặc multi choice.',
        ),
        routeName: '/bottom_sheet_selects_screen',
        icon: Icons.list_alt_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Checkbox', vi: 'Checkbox'),
        description: DocsText(
          en: 'Binary, tristate, boxed, and selectbox selection.',
          vi: 'Lựa chọn binary, tristate, boxed và selectbox.',
        ),
        routeName: '/checkboxes_screen',
        icon: Icons.check_box_outlined,
      ),
      _CatalogItem(
        title: DocsText(en: 'Radio', vi: 'Radio'),
        description: DocsText(
          en: 'Single-choice grouped selection.',
          vi: 'Lựa chọn một giá trị trong một nhóm.',
        ),
        routeName: '/radios_screen',
        icon: Icons.radio_button_checked,
      ),
      _CatalogItem(
        title: DocsText(en: 'Switch', vi: 'Switch'),
        description: DocsText(
          en: 'On/off control with label placement and sizes.',
          vi: 'Điều khiển bật/tắt với vị trí label và các size.',
        ),
        routeName: '/switches_screen',
        icon: Icons.toggle_on_outlined,
      ),
    ],
  ),
  _CatalogGroup(
    title: DocsText(en: 'Feedback and overlays', vi: 'Phản hồi và overlay'),
    description: DocsText(
      en: 'Transient surfaces used for status, confirmation, and tasks.',
      vi: 'Các surface tạm thời cho trạng thái, xác nhận và tác vụ.',
    ),
    items: [
      _CatalogItem(
        title: DocsText(en: 'Alert', vi: 'Alert'),
        description: DocsText(
          en: 'Inline and overlay alerts with placement and auto-close.',
          vi: 'Alert inline và overlay với placement và tự động đóng.',
        ),
        routeName: '/alerts_screen',
        icon: Icons.info_outline,
      ),
      _CatalogItem(
        title: DocsText(en: 'Bottom Sheet', vi: 'Bottom Sheet'),
        description: DocsText(
          en: 'Contextual sheets for forms and actions.',
          vi: 'Sheet ngữ cảnh cho form và hành động.',
        ),
        routeName: '/bottom_sheets_screen',
        icon: Icons.vertical_align_bottom,
      ),
      _CatalogItem(
        title: DocsText(en: 'Modal', vi: 'Modal'),
        description: DocsText(
          en: 'Dialog confirmation and custom body flows.',
          vi: 'Dialog xác nhận và các flow với body tùy biến.',
        ),
        routeName: '/modals_screen',
        icon: Icons.open_in_new,
      ),
    ],
  ),
];

WidgetDoc widgetDocFor(String id) => _widgetDocs[id]!;

PropDoc prop(
  String name,
  String type,
  String defaultValue,
  String en,
  String vi, {
  bool required = false,
}) {
  return PropDoc(
    name: name,
    type: type,
    defaultValue: defaultValue,
    required: required,
    description: DocsText(en: en, vi: vi),
  );
}

final Map<String, WidgetDoc> _widgetDocs = {
  'text': WidgetDoc(
    title: const DocsText(en: 'AppText', vi: 'AppText'),
    description: const DocsText(
      en:
          'Use AppText instead of raw Text when you want typography tokens, consistent color handling, and predictable overflow behavior.',
      vi:
          'Dùng AppText thay cho Text thường khi cần typography token, màu sắc nhất quán và hành vi overflow dễ dự đoán.',
    ),
    quickUse: const DocsText(
      en:
          "AppText(\n  text: 'Product name',\n  size: AppTextSize.bodyMBold,\n  color: ColorTokens.textDefault,\n)",
      vi:
          "AppText(\n  text: 'Tên sản phẩm',\n  size: AppTextSize.bodyMBold,\n  color: ColorTokens.textDefault,\n)",
    ),
    props: [
      prop(
        'text',
        'String',
        '-',
        'Text content.',
        'Nội dung hiển thị.',
        required: true,
      ),
      prop(
        'size',
        'AppTextSize?',
        'bodyMRegular',
        'Tokenized text style.',
        'Text style theo token.',
      ),
      prop('color', 'Color?', '-', 'Overrides text color.', 'Ghi đè màu chữ.'),
      prop(
        'style',
        'TextStyle?',
        '-',
        'Merged after the token style.',
        'Được merge sau style token.',
      ),
      prop(
        'maxLines',
        'int?',
        '-',
        'Limits visible lines.',
        'Giới hạn số dòng hiển thị.',
      ),
      prop(
        'overflow',
        'TextOverflow?',
        '-',
        'Controls overflow handling.',
        'Điều khiển cách xử lý tràn chữ.',
      ),
      prop(
        'textAlign',
        'TextAlign?',
        '-',
        'Text alignment.',
        'Căn lề nội dung chữ.',
      ),
    ],
  ),
  'button': WidgetDoc(
    title: const DocsText(en: 'AppButton', vi: 'AppButton'),
    description: const DocsText(
      en:
          'Use AppButton for actions. It includes variants, sizes, optional icons, loading, disabled, and full-width behavior.',
      vi:
          'Dùng AppButton cho hành động. Widget hỗ trợ variant, size, icon, loading, disabled và full-width.',
    ),
    quickUse: const DocsText(
      en:
          "AppButton(\n  text: 'Save',\n  variant: AppButtonVariant.primary,\n  size: AppButtonSize.medium,\n  iconLeft: const Icon(Icons.save, color: ColorTokens.white),\n  onPressed: () {},\n)",
      vi:
          "AppButton(\n  text: 'Lưu',\n  variant: AppButtonVariant.primary,\n  size: AppButtonSize.medium,\n  iconLeft: const Icon(Icons.save, color: ColorTokens.white),\n  onPressed: () {},\n)",
    ),
    props: [
      prop(
        'text',
        'String',
        '-',
        'Button label.',
        'Nhãn của nút.',
        required: true,
      ),
      prop(
        'onPressed',
        'VoidCallback?',
        '-',
        'Called when the button is pressed.',
        'Được gọi khi bấm nút.',
      ),
      prop(
        'variant',
        'AppButtonVariant?',
        'fallback',
        'Visual style: primary, outline, danger, warning, link, text, dash.',
        'Kiểu hiển thị: primary, outline, danger, warning, link, text, dash.',
      ),
      prop(
        'size',
        'AppButtonSize?',
        'medium',
        'Controls height, padding, and text size.',
        'Điều khiển chiều cao, padding và cỡ chữ.',
      ),
      prop(
        'iconLeft / iconRight',
        'Widget?',
        '-',
        'Optional leading or trailing icon.',
        'Icon nằm bên trái hoặc bên phải.',
      ),
      prop(
        'isFullWidth',
        'bool?',
        'false',
        'Expands to available width.',
        'Mở rộng theo chiều ngang khả dụng.',
      ),
      prop(
        'isLoading',
        'bool?',
        'false',
        'Shows loading state and blocks interaction.',
        'Hiển thị loading và khóa tương tác.',
      ),
      prop(
        'isDisabled',
        'bool?',
        'false',
        'Disables interaction visually and functionally.',
        'Tắt tương tác và trạng thái hiển thị.',
      ),
    ],
  ),
  'skeleton': WidgetDoc(
    title: const DocsText(en: 'AppSkeleton', vi: 'AppSkeleton'),
    description: const DocsText(
      en:
          'Use AppSkeleton to preserve layout while content is loading. Combine several instances to mirror the final UI structure.',
      vi:
          'Dùng AppSkeleton để giữ chỗ giao diện khi dữ liệu đang tải. Có thể ghép nhiều instance để mô phỏng cấu trúc UI cuối cùng.',
    ),
    quickUse: const DocsText(
      en:
          "Column(\n  crossAxisAlignment: CrossAxisAlignment.start,\n  children: const [\n    AppSkeleton(width: 160, height: 20),\n    SizedBox(height: 8),\n    AppSkeleton(height: 14),\n    SizedBox(height: 8),\n    AppSkeleton(width: 56, height: 56, shape: BoxShape.circle),\n  ],\n)",
      vi:
          "Column(\n  crossAxisAlignment: CrossAxisAlignment.start,\n  children: const [\n    AppSkeleton(width: 160, height: 20),\n    SizedBox(height: 8),\n    AppSkeleton(height: 14),\n    SizedBox(height: 8),\n    AppSkeleton(width: 56, height: 56, shape: BoxShape.circle),\n  ],\n)",
    ),
    props: [
      prop(
        'width',
        'double?',
        '-',
        'Optional width. Leave null to follow parent constraints.',
        'Chiều rộng tùy chọn. Để null để đi theo constraint của parent.',
      ),
      prop(
        'height',
        'double?',
        '16',
        'Skeleton height. Circle shape also uses it as fallback width.',
        'Chiều cao skeleton. Với shape tròn, giá trị này cũng được dùng làm width dự phòng.',
      ),
      prop(
        'shape',
        'BoxShape',
        'BoxShape.rectangle',
        'Rectangle by default, or circle for avatars and thumbnails.',
        'Mặc định là hình chữ nhật, hoặc hình tròn cho avatar và thumbnail.',
      ),
      prop(
        'borderRadius',
        'BorderRadiusGeometry?',
        'RadiusTokens.radiusL',
        'Rounded corners for rectangle skeletons.',
        'Bo góc cho skeleton hình chữ nhật.',
      ),
      prop(
        'baseColor',
        'Color?',
        'ColorTokens.borderSecondary',
        'Base shimmer color.',
        'Màu nền chính của shimmer.',
      ),
      prop(
        'highlightColor',
        'Color?',
        'ColorTokens.bgWarm',
        'Moving highlight color.',
        'Màu highlight chạy qua skeleton.',
      ),
      prop(
        'duration',
        'Duration',
        '1200ms',
        'Speed of the shimmer loop.',
        'Tốc độ lặp của shimmer.',
      ),
      prop(
        'isAnimated',
        'bool',
        'true',
        'Disables shimmer and renders a static placeholder when false.',
        'Tắt shimmer và render placeholder tĩnh khi là false.',
      ),
    ],
  ),
  'loading': WidgetDoc(
    title: const DocsText(en: 'AppLoadingSpinner', vi: 'AppLoadingSpinner'),
    description: const DocsText(
      en:
          'Use AppLoadingSpinner for active loading states that should communicate progress instead of reserving layout like a skeleton.',
      vi:
          'Dùng AppLoadingSpinner cho trạng thái loading chủ động cần truyền tải tiến trình, thay vì chỉ giữ chỗ bố cục như skeleton.',
    ),
    quickUse: const DocsText(
      en:
          "const AppLoadingSpinner(\n  size: IconSizeTokens.iconSizeL,\n  color: ColorTokens.primaryDefault,\n)\n",
      vi:
          "const AppLoadingSpinner(\n  size: IconSizeTokens.iconSizeL,\n  color: ColorTokens.primaryDefault,\n)\n",
    ),
    props: [
      prop(
        'size',
        'double',
        'IconSizeTokens.iconSizeL',
        'Controls the spinner width and height.',
        'Điều khiển chiều rộng và chiều cao của spinner.',
      ),
      prop(
        'strokeWidth',
        'double',
        '2',
        'Thickness of the circular progress stroke.',
        'Độ dày của nét spinner.',
      ),
      prop(
        'color',
        'Color?',
        'ColorTokens.primaryDefault',
        'Active spinner color.',
        'Màu hiển thị chính của spinner.',
      ),
      prop(
        'backgroundColor',
        'Color?',
        '-',
        'Optional track color behind the progress stroke.',
        'Màu nền track phía sau nét progress.',
      ),
      prop(
        'value',
        'double?',
        '-',
        'Set a determinate progress value from 0 to 1 when needed.',
        'Thiết lập giá trị tiến trình xác định từ 0 đến 1 khi cần.',
      ),
      prop(
        'padding',
        'EdgeInsetsGeometry',
        'EdgeInsets.zero',
        'Adds outer spacing without requiring an extra wrapper.',
        'Thêm khoảng cách bên ngoài mà không cần bọc thêm widget.',
      ),
      prop(
        'semanticsLabel / semanticsValue',
        'String?',
        '-',
        'Accessibility labels for assistive technologies.',
        'Nhãn trợ năng cho các công cụ hỗ trợ truy cập.',
      ),
    ],
  ),
  'checkbox': WidgetDoc(
    title: const DocsText(en: 'AppCheckbox', vi: 'AppCheckbox'),
    description: const DocsText(
      en:
          'Use AppCheckbox for multiple selection, tristate flows, boxed options, or selectbox-style choices.',
      vi:
          'Dùng AppCheckbox cho multi-select, tristate, option dạng boxed hoặc selectbox.',
    ),
    quickUse: const DocsText(
      en:
          "bool? selected = false;\n\nAppCheckbox(\n  value: selected,\n  label: 'Remember setting',\n  onChanged: (value) => setState(() => selected = value),\n)",
      vi:
          "bool? daChon = false;\n\nAppCheckbox(\n  value: daChon,\n  label: 'Ghi nhớ thiết lập',\n  onChanged: (value) => setState(() => daChon = value),\n)",
    ),
    props: [
      prop(
        'value',
        'bool?',
        '-',
        'false, true, or null when tristate is enabled.',
        'false, true hoặc null khi bật tristate.',
        required: true,
      ),
      prop(
        'onChanged',
        'ValueChanged<bool?>?',
        '-',
        'Receives the next checked value.',
        'Nhận giá trị checked tiếp theo.',
      ),
      prop(
        'size',
        'AppCheckboxSize?',
        'medium',
        'Visual size of box and label.',
        'Kích thước box và label.',
      ),
      prop(
        'variant',
        'AppCheckboxVariant?',
        'standard',
        'standard, boxed, or selectbox.',
        'standard, boxed hoặc selectbox.',
      ),
      prop(
        'label / labelWidget',
        'String? / Widget?',
        '-',
        'Text label or custom label widget.',
        'Label dạng text hoặc widget tùy biến.',
      ),
      prop(
        'labelPosition',
        'AppCheckboxLabelPosition?',
        'right',
        'Places label left or right.',
        'Đặt label bên trái hoặc phải.',
      ),
      prop(
        'tristate',
        'bool?',
        'false',
        'Allows null as indeterminate value.',
        'Cho phép null như trạng thái indeterminate.',
      ),
      prop(
        'isDisabled / isReadOnly',
        'bool?',
        'false',
        'Blocks or limits interaction.',
        'Chặn hoặc giới hạn tương tác.',
      ),
    ],
  ),
  'divider': WidgetDoc(
    title: const DocsText(en: 'AppDivider', vi: 'AppDivider'),
    description: const DocsText(
      en:
          'Use AppDivider to separate related areas with semantic status colors or custom thickness.',
      vi:
          'Dùng AppDivider để tách các vùng liên quan bằng màu semantic hoặc độ dày tùy biến.',
    ),
    quickUse: const DocsText(
      en:
          "const AppDivider(\n  variant: AppDividerVariant.info,\n  thickness: 2,\n)",
      vi:
          "const AppDivider(\n  variant: AppDividerVariant.info,\n  thickness: 2,\n)",
    ),
    props: [
      prop(
        'orientation',
        'AppDividerOrientation?',
        'horizontal',
        'Horizontal or vertical divider.',
        'Divider ngang hoặc dọc.',
      ),
      prop(
        'variant',
        'AppDividerVariant?',
        'defaultValue',
        'Semantic color variant.',
        'Biến thể màu semantic.',
      ),
      prop(
        'color',
        'Color?',
        '-',
        'Overrides variant color.',
        'Ghi đè màu của variant.',
      ),
      prop(
        'thickness',
        'double?',
        '2.0',
        'Divider thickness.',
        'Độ dày của divider.',
      ),
      prop(
        'length',
        'double?',
        '-',
        'Fixed width or height.',
        'Chiều rộng hoặc cao cố định.',
      ),
      prop(
        'indent / endIndent',
        'double?',
        '-',
        'Leading and trailing inset.',
        'Khoảng lùi đầu và cuối.',
      ),
    ],
  ),
  'label': WidgetDoc(
    title: const DocsText(en: 'AppLabel', vi: 'AppLabel'),
    description: const DocsText(
      en:
          'Use AppLabel for form labels that need required marks, optional text, and contextual info.',
      vi:
          'Dùng AppLabel cho nhãn form cần dấu bắt buộc, optional text và thông tin ngữ cảnh.',
    ),
    quickUse: const DocsText(
      en:
          "const AppLabel(\n  text: 'Email',\n  isRequired: true,\n  showInfoIcon: true,\n  tooltipMessage: 'Used for order notifications',\n)",
      vi:
          "const AppLabel(\n  text: 'Email',\n  isRequired: true,\n  showInfoIcon: true,\n  tooltipMessage: 'Dùng để nhận thông báo đơn hàng',\n)",
    ),
    props: [
      prop(
        'text',
        'String',
        '-',
        'Label content.',
        'Nội dung label.',
        required: true,
      ),
      prop(
        'size',
        'AppLabelSize?',
        'medium',
        'Controls text and icon sizing.',
        'Điều khiển cỡ chữ và icon.',
      ),
      prop(
        'isRequired',
        'bool?',
        'false',
        'Shows required mark.',
        'Hiển thị dấu bắt buộc.',
      ),
      prop(
        'requiredPosition',
        'AppLabelRequiredPosition?',
        'trailing',
        'Places required mark before, after, or both.',
        'Đặt dấu bắt buộc trước, sau hoặc cả hai.',
      ),
      prop(
        'isOptional / optionalText',
        'bool? / String?',
        'false / (optional)',
        'Shows optional helper text.',
        'Hiển thị chữ tùy chọn.',
      ),
      prop(
        'showInfoIcon',
        'bool?',
        'false',
        'Shows info icon with optional tooltip.',
        'Hiển thị icon info kèm tooltip tùy chọn.',
      ),
      prop(
        'textStyle / colors',
        'TextStyle? / Color?',
        '-',
        'Overrides typography and colors.',
        'Ghi đè typography và màu sắc.',
      ),
    ],
  ),
  'alert': WidgetDoc(
    title: const DocsText(en: 'AppAlert', vi: 'AppAlert'),
    description: const DocsText(
      en:
          'Use AppAlert for inline or overlay feedback. Overlay alerts support placement, offset, and auto-close.',
      vi:
          'Dùng AppAlert cho phản hồi inline hoặc overlay. Overlay hỗ trợ placement, offset và auto-close.',
    ),
    quickUse: const DocsText(
      en:
          "final controller = AppAlert.show(\n  context: context,\n  type: AppAlertType.success,\n  title: 'Saved',\n  description: 'Changes were saved successfully.',\n  autoCloseDuration: const Duration(seconds: 3),\n);\n\nAppAlert.close(controller);",
      vi:
          "final controller = AppAlert.show(\n  context: context,\n  type: AppAlertType.success,\n  title: 'Đã lưu',\n  description: 'Thay đổi đã được lưu thành công.',\n  autoCloseDuration: const Duration(seconds: 3),\n);\n\nAppAlert.close(controller);",
    ),
    props: [
      prop(
        'title',
        'String',
        '-',
        'Main alert title.',
        'Tiêu đề chính của alert.',
        required: true,
      ),
      prop(
        'type',
        'AppAlertType',
        'info',
        'fallback, info, warning, danger, success.',
        'fallback, info, warning, danger, success.',
      ),
      prop(
        'size',
        'AppAlertSize',
        'medium',
        'Controls alert width and spacing.',
        'Điều khiển chiều rộng và spacing.',
      ),
      prop(
        'description',
        'String?',
        '-',
        'Supporting message.',
        'Nội dung mô tả.',
      ),
      prop(
        'actions',
        'List<AppAlertAction>',
        'const []',
        'Optional action links/buttons.',
        'Danh sách action tùy chọn.',
      ),
      prop(
        'visible / dismissible',
        'bool',
        'true',
        'Controls render and dismiss behavior.',
        'Điều khiển hiển thị và khả năng đóng.',
      ),
      prop(
        'placement / offset',
        'AppAlertPlacement / Offset',
        'top / zero',
        'Available on AppAlert.show overlay.',
        'Dùng với overlay AppAlert.show.',
      ),
      prop(
        'autoCloseDuration',
        'Duration?',
        '-',
        'Automatically closes overlay after delay.',
        'Tự động đóng overlay sau thời gian chờ.',
      ),
    ],
  ),
  'bottomSheet': WidgetDoc(
    title: const DocsText(en: 'AppBottomSheet', vi: 'AppBottomSheet'),
    description: const DocsText(
      en:
          'Use AppBottomSheet for contextual tasks, short forms, and action groups anchored to the bottom edge.',
      vi:
          'Dùng AppBottomSheet cho tác vụ theo ngữ cảnh, form ngắn và nhóm action neo ở cạnh dưới.',
    ),
    quickUse: const DocsText(
      en:
          "AppBottomSheet.show<void>(\n  context: context,\n  builder: (sheetContext) => AppBottomSheet(\n    title: 'Filter products',\n    description: 'Choose the conditions to apply.',\n    titlePrimaryAction: 'Apply',\n    onPrimaryAction: () => AppBottomSheet.close(sheetContext),\n    child: const AppText(text: 'Sheet content'),\n  ),\n);",
      vi:
          "AppBottomSheet.show<void>(\n  context: context,\n  builder: (sheetContext) => AppBottomSheet(\n    title: 'Lọc sản phẩm',\n    description: 'Chọn điều kiện cần áp dụng.',\n    titlePrimaryAction: 'Áp dụng',\n    onPrimaryAction: () => AppBottomSheet.close(sheetContext),\n    child: const AppText(text: 'Nội dung sheet'),\n  ),\n);",
    ),
    props: [
      prop(
        'child',
        'Widget',
        '-',
        'Main body content.',
        'Nội dung chính.',
        required: true,
      ),
      prop(
        'title',
        'String',
        '-',
        'Sheet title.',
        'Tiêu đề sheet.',
        required: true,
      ),
      prop(
        'description',
        'String?',
        '-',
        'Supporting text below title.',
        'Mô tả nằm dưới tiêu đề.',
      ),
      prop(
        'size',
        'AppBottomSheetSize?',
        'medium',
        'Controls max height and spacing.',
        'Điều khiển max height và spacing.',
      ),
      prop(
        'buttons',
        'List<Widget>?',
        '-',
        'Overrides default action buttons.',
        'Ghi đè các nút action mặc định.',
      ),
      prop(
        'actionOrientation',
        'AppBottomSheetActionOrientation?',
        'vertical',
        'Stacks actions vertically or horizontally.',
        'Xếp action dọc hoặc ngang.',
      ),
      prop(
        'showDragHandle / showCloseIcon',
        'bool?',
        'true',
        'Controls sheet chrome.',
        'Điều khiển thanh kéo và icon đóng.',
      ),
      prop(
        'titlePrimaryAction / callbacks',
        'String? / VoidCallback?',
        '-',
        'Default footer action labels and handlers.',
        'Nhãn và callback cho footer action mặc định.',
      ),
    ],
  ),
  'textField': WidgetDoc(
    title: const DocsText(
      en: 'AppTextField, AppPasswordField, and AppSearchField',
      vi: 'AppTextField, AppPasswordField và AppSearchField',
    ),
    description: const DocsText(
      en:
          'Use AppTextField for generic form input, AppPasswordField for password entry with built-in visibility toggle, and AppSearchField when you need debounced search callbacks.',
      vi:
          'Dùng AppTextField cho input tổng quát, AppPasswordField cho nhập mật khẩu với nút ẩn/hiện sẵn có, và AppSearchField khi cần callback search có debounce.',
    ),
    quickUse: const DocsText(
      en:
          "AppPasswordField(\n  labelText: 'Password',\n  hintText: 'Enter your password',\n  helperText: 'Minimum 8 characters',\n  validate: (value) => value.isEmpty ? 'Password is required' : null,\n)",
      vi:
          "AppPasswordField(\n  labelText: 'Mật khẩu',\n  hintText: 'Nhập mật khẩu',\n  helperText: 'Tối thiểu 8 ký tự',\n  validate: (value) => value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,\n)",
    ),
    props: [
      prop(
        'AppPasswordField',
        'Widget',
        '-',
        'Specialized password input built on AppTextField.',
        'Widget nhập mật khẩu chuyên biệt được xây trên AppTextField.',
      ),
      prop(
        'hintText / labelText',
        'String?',
        '-',
        'Placeholder and label content.',
        'Placeholder và label.',
      ),
      prop(
        'variant',
        'AppTextFieldVariant',
        'primary',
        'primary, danger, warning, success.',
        'primary, danger, warning, success.',
      ),
      prop(
        'size',
        'AppTextFieldSize',
        'medium',
        'Controls input height and text sizing.',
        'Điều khiển chiều cao input và cỡ chữ.',
      ),
      prop(
        'isRounded',
        'bool?',
        'false',
        'Uses rounded shape.',
        'Dùng hình dạng bo tròn.',
      ),
      prop(
        'helperText / errorText',
        'String?',
        '-',
        'Helper and error messages.',
        'Thông tin hỗ trợ và lỗi.',
      ),
      prop(
        'prefixIcon / suffixIcon',
        'Widget?',
        '-',
        'Icon slots inside input.',
        'Slot icon trong input.',
      ),
      prop(
        'prefix / suffix',
        'Widget?',
        '-',
        'Content slots near the text field.',
        'Slot nội dung gần field.',
      ),
      prop(
        'controller / focusNode',
        'TextEditingController? / FocusNode?',
        '-',
        'External input control.',
        'Điều khiển input từ bên ngoài.',
      ),
      prop(
        'showVisibilityToggle',
        'bool',
        'true',
        'Shows the built-in password visibility action.',
        'Hiển thị action ẩn/hiện mật khẩu mặc định.',
      ),
      prop(
        'initiallyObscured',
        'bool',
        'true',
        'Starts with obscured password text.',
        'Khởi tạo với nội dung mật khẩu đang bị ẩn.',
      ),
      prop(
        'visibleIcon / obscuredIcon',
        'Widget?',
        '-',
        'Overrides the visibility toggle icons.',
        'Ghi đè icon cho trạng thái hiện hoặc ẩn mật khẩu.',
      ),
      prop(
        'showClearTextAction',
        'bool',
        'false in AppPasswordField',
        'Keeps the inherited clear action disabled by default for password UX.',
        'Giữ clear action kế thừa ở trạng thái tắt mặc định để phù hợp UX nhập mật khẩu.',
      ),
      prop(
        'onVisibilityChanged',
        'ValueChanged<bool>?',
        '-',
        'Reports whether the field is currently obscured.',
        'Trả về trạng thái field đang ẩn hay hiện mật khẩu.',
      ),
      prop(
        'validate',
        'String? Function(String)?',
        '-',
        'Returns validation error text.',
        'Trả về text lỗi validate.',
      ),
    ],
  ),
  'dateTimeField': WidgetDoc(
    title: const DocsText(en: 'AppDateTimeField', vi: 'AppDateTimeField'),
    description: const DocsText(
      en:
          'Use AppDateTimeField to collect date, time, or combined date-time values with tokenized input styling.',
      vi:
          'Dùng AppDateTimeField để nhập ngày, giờ hoặc ngày-giờ với styling input theo token.',
    ),
    quickUse: const DocsText(
      en:
          "AppDateTimeField(\n  mode: AppDateTimeFieldMode.date,\n  labelText: 'Delivery date',\n  hintText: 'Select date',\n  onChanged: (date) {},\n)",
      vi:
          "AppDateTimeField(\n  mode: AppDateTimeFieldMode.date,\n  labelText: 'Ngày giao hàng',\n  hintText: 'Chọn ngày',\n  onChanged: (date) {},\n)",
    ),
    props: [
      prop(
        'mode',
        'AppDateTimeFieldMode',
        'date',
        'date, time, or dateTime.',
        'date, time hoặc dateTime.',
      ),
      prop(
        'value / timeValue',
        'DateTime? / TimeOfDay?',
        '-',
        'Controlled selected value.',
        'Giá trị đã chọn dạng controlled.',
      ),
      prop(
        'onChanged / onTimeChanged',
        'ValueChanged?',
        '-',
        'Receives selected date or time.',
        'Nhận ngày hoặc giờ đã chọn.',
      ),
      prop(
        'firstDate / lastDate',
        'DateTime?',
        '-',
        'Selectable date range.',
        'Khoảng ngày được phép chọn.',
      ),
      prop(
        'dateFormatter / timeFormatter',
        'Function?',
        '-',
        'Custom display formatter.',
        'Format hiển thị tùy biến.',
      ),
      prop(
        'pickerStyle',
        'AppDateTimePickerStyle?',
        '-',
        'Customizes picker text and colors.',
        'Tùy biến text và màu của picker.',
      ),
      prop(
        'selectableDayPredicate',
        'SelectableDayPredicate?',
        '-',
        'Disables unavailable dates.',
        'Vô hiệu hóa các ngày không hợp lệ.',
      ),
    ],
  ),
  'otpField': WidgetDoc(
    title: const DocsText(en: 'AppOtpField', vi: 'AppOtpField'),
    description: const DocsText(
      en:
          'Use AppOtpField when users need to enter an SMS, email, or authenticator OTP. The widget keeps the interaction simple by sanitizing digits, supporting paste, and exposing a completion callback.',
      vi:
          'Dùng AppOtpField khi người dùng cần nhập mã OTP từ SMS, email hoặc ứng dụng xác thực. Widget tự lọc số, hỗ trợ paste và cung cấp callback khi nhập đủ mã.',
    ),
    quickUse: const DocsText(
      en:
          "AppOtpField(\n  controller: controller,\n  onChanged: (value) {\n    debugPrint('OTP: \$value');\n  },\n  onCompleted: (value) {\n    debugPrint('Completed OTP: \$value');\n  },\n)",
      vi:
          "AppOtpField(\n  controller: controller,\n  onChanged: (value) {\n    debugPrint('OTP: \$value');\n  },\n  onCompleted: (value) {\n    debugPrint('Hoan tat OTP: \$value');\n  },\n)",
    ),
    props: [
      prop(
        'length',
        'int',
        '6',
        'Number of OTP cells and maximum accepted digits.',
        'Số lượng ô OTP và số digit tối đa được chấp nhận.',
      ),
      prop(
        'controller / focusNode',
        'TextEditingController? / FocusNode?',
        '-',
        'External control for the input value and focus.',
        'Điều khiển giá trị input và focus từ bên ngoài.',
      ),
      prop(
        'onChanged',
        'ValueChanged<String>?',
        '-',
        'Called whenever the sanitized OTP value changes.',
        'Được gọi mỗi khi giá trị OTP sau khi sanitize thay đổi.',
      ),
      prop(
        'onCompleted',
        'ValueChanged<String>?',
        '-',
        'Called when the OTP reaches the configured length.',
        'Được gọi khi OTP đạt đủ độ dài đã cấu hình.',
      ),
      prop(
        'autofocus',
        'bool',
        'false',
        'Requests focus automatically on first build.',
        'Tự động xin focus ở lần build đầu tiên.',
      ),
      prop(
        'isDisabled',
        'bool',
        'false',
        'Disables focus and text entry.',
        'Vô hiệu hóa focus và nhập liệu.',
      ),
      prop(
        'cellWidth / cellHeight',
        'double',
        '48 / 56',
        'Base size of each OTP digit cell.',
        'Kích thước cơ bản của từng ô digit OTP.',
      ),
      prop(
        'cellSpacing',
        'double',
        'SpacingTokens.spaceM',
        'Horizontal space between cells.',
        'Khoảng cách ngang giữa các ô.',
      ),
      prop(
        'borderRadius',
        'BorderRadiusGeometry?',
        'RadiusTokens.radiusLgBorderRadius',
        'Corner radius used by each OTP cell.',
        'Bo góc áp dụng cho từng ô OTP.',
      ),
    ],
  ),
  'dropdown': WidgetDoc(
    title: const DocsText(en: 'AppDropdown', vi: 'AppDropdown'),
    description: const DocsText(
      en:
          'Use AppDropdown for local or remote selectable lists with search, empty, loading, error, and pagination states.',
      vi:
          'Dùng AppDropdown cho danh sách local hoặc remote với search, empty, loading, error và phân trang.',
    ),
    quickUse: const DocsText(
      en:
          "String? value;\nfinal items = ['Pending', 'Done'];\n\nAppDropdown<String>(\n  hintText: 'Choose status',\n  items: items,\n  value: value,\n  itemAsString: (item) => item,\n  onChanged: (next) => setState(() => value = next),\n  isSearchable: true,\n)",
      vi:
          "String? giaTri;\nfinal items = ['Đang xử lý', 'Hoàn tất'];\n\nAppDropdown<String>(\n  hintText: 'Chọn trạng thái',\n  items: items,\n  value: giaTri,\n  itemAsString: (item) => item,\n  onChanged: (next) => setState(() => giaTri = next),\n  isSearchable: true,\n)",
    ),
    props: [
      prop(
        'items',
        'List<T>',
        '-',
        'Selectable options.',
        'Danh sách lựa chọn.',
        required: true,
      ),
      prop(
        'value',
        'T?',
        '-',
        'Current selected value.',
        'Giá trị đang chọn.',
        required: true,
      ),
      prop(
        'hintText',
        'String',
        '-',
        'Placeholder when no value is selected.',
        'Placeholder khi chưa chọn.',
        required: true,
      ),
      prop(
        'onChanged',
        'ValueChanged<T?>?',
        '-',
        'Receives selected value.',
        'Nhận giá trị được chọn.',
        required: true,
      ),
      prop(
        'itemAsString',
        'String Function(T)',
        '-',
        'Maps item to display text.',
        'Chuyển item thành text hiển thị.',
        required: true,
      ),
      prop(
        'isSearchable',
        'bool?',
        'false',
        'Shows search input in the menu.',
        'Hiển thị input search trong menu.',
      ),
      prop(
        'enableLocalFilter',
        'bool',
        'true',
        'Filters items locally or delegates remote search.',
        'Lọc local hoặc ủy quyền cho remote search.',
      ),
      prop(
        'hasMore / onLoadMore',
        'bool / VoidCallback?',
        'false / -',
        'Supports paginated menus.',
        'Hỗ trợ menu phân trang.',
      ),
    ],
  ),
  'bottomSheetSelect': WidgetDoc(
    title: const DocsText(
      en: 'AppBottomSheetSelect',
      vi: 'AppBottomSheetSelect',
    ),
    description: const DocsText(
      en:
          'Use AppBottomSheetSelect when the trigger should stay as a field but the option list needs to open inside AppBottomSheet, including remote search, pagination, and multi-choice flows.',
      vi:
          'Dùng AppBottomSheetSelect khi trigger nên giữ dạng field nhưng danh sách lựa chọn cần mở trong AppBottomSheet, gồm cả remote search, phân trang và multi-choice.',
    ),
    quickUse: const DocsText(
      en:
          "AppBottomSheetSelect<String>.single(\n  labelText: 'Tax method',\n  hintText: 'Choose tax method',\n  items: methods,\n  value: selectedMethod,\n  itemAsString: (item) => item,\n  onChanged: (next) => setState(() => selectedMethod = next),\n  isSearchable: true,\n)",
      vi:
          "AppBottomSheetSelect<String>.single(\n  labelText: 'Phương pháp tính thuế',\n  hintText: 'Chọn phương pháp tính thuế',\n  items: methods,\n  value: selectedMethod,\n  itemAsString: (item) => item,\n  onChanged: (next) => setState(() => selectedMethod = next),\n  isSearchable: true,\n)",
    ),
    props: [
      prop(
        'single / multi',
        'Named constructors',
        '-',
        'Use .single for one selected value and .multi for multiple selected values.',
        'Dùng .single cho một giá trị và .multi cho nhiều giá trị.',
      ),
      prop(
        'items',
        'List<T>',
        '-',
        'Selectable options shown inside the bottom sheet.',
        'Danh sách lựa chọn hiển thị trong bottom sheet.',
        required: true,
      ),
      prop(
        'value / values',
        'T? / List<T>',
        '-',
        'Controlled selection for single or multi mode.',
        'Giá trị controlled cho single hoặc multi mode.',
      ),
      prop(
        'itemAsString',
        'String Function(T)',
        '-',
        'Maps an option to the display label.',
        'Chuyển option thành text hiển thị.',
        required: true,
      ),
      prop(
        'itemDescriptionAsString',
        'String? Function(T)?',
        '-',
        'Optional secondary line inside each option tile.',
        'Dòng mô tả phụ tùy chọn trong từng item.',
      ),
      prop(
        'isSearchable / enableLocalFilter',
        'bool',
        'false / true',
        'Enables local search or remote search callbacks.',
        'Bật local search hoặc remote search callback.',
      ),
      prop(
        'isLoading / sheetErrorText / onRetry',
        'bool / String? / VoidCallback?',
        '-',
        'Controls sheet loading and retry states.',
        'Điều khiển trạng thái loading và retry trong sheet.',
      ),
      prop(
        'hasMore / isLoadingMore / onLoadMore',
        'bool / bool / VoidCallback?',
        '-',
        'Supports infinite scroll for remote data.',
        'Hỗ trợ phân trang vô hạn cho dữ liệu remote.',
      ),
      prop(
        'sheetTitle / sheetDescription',
        'String?',
        '-',
        'Customizes the AppBottomSheet header.',
        'Tùy biến phần header của AppBottomSheet.',
      ),
    ],
  ),
  'modal': WidgetDoc(
    title: const DocsText(en: 'AppModal', vi: 'AppModal'),
    description: const DocsText(
      en:
          'Use AppModal for confirmation, decision, and focused task flows. It can return a typed result through AppModal.show.',
      vi:
          'Dùng AppModal cho xác nhận, quyết định và tác vụ tập trung. Có thể trả result có kiểu qua AppModal.show.',
    ),
    quickUse: const DocsText(
      en:
          "final confirmed = await AppModal.show<bool>(\n  context: context,\n  builder: (dialogContext) => AppModal(\n    modalType: AppModalType.danger,\n    title: 'Delete item?',\n    description: 'This action cannot be undone.',\n    titleCancelAction: 'Cancel',\n    onCancelAction: () => AppModal.close(dialogContext, false),\n    titlePrimaryAction: 'Delete',\n    onPrimaryAction: () => AppModal.close(dialogContext, true),\n    child: const SizedBox.shrink(),\n  ),\n);",
      vi:
          "final xacNhan = await AppModal.show<bool>(\n  context: context,\n  builder: (dialogContext) => AppModal(\n    modalType: AppModalType.danger,\n    title: 'Xóa mục này?',\n    description: 'Hành động này không thể hoàn tác.',\n    titleCancelAction: 'Hủy',\n    onCancelAction: () => AppModal.close(dialogContext, false),\n    titlePrimaryAction: 'Xóa',\n    onPrimaryAction: () => AppModal.close(dialogContext, true),\n    child: const SizedBox.shrink(),\n  ),\n);",
    ),
    props: [
      prop(
        'child',
        'Widget',
        '-',
        'Body content.',
        'Nội dung body.',
        required: true,
      ),
      prop(
        'title',
        'String',
        '-',
        'Modal title.',
        'Tiêu đề modal.',
        required: true,
      ),
      prop(
        'description',
        'String?',
        '-',
        'Supporting message.',
        'Nội dung mô tả.',
      ),
      prop(
        'modalType',
        'AppModalType',
        'normal',
        'normal, info, warning, danger, success.',
        'normal, info, warning, danger, success.',
      ),
      prop(
        'size',
        'AppModalSize',
        'small',
        'Controls modal width.',
        'Điều khiển chiều rộng modal.',
      ),
      prop(
        'buttons',
        'List<Widget>?',
        '-',
        'Overrides default action layout.',
        'Ghi đè layout action mặc định.',
      ),
      prop(
        'titleBack/Cancel/Secondary/PrimaryAction',
        'String?',
        '-',
        'Default action labels.',
        'Nhãn cho các action mặc định.',
      ),
      prop(
        'onBack/Cancel/Secondary/PrimaryAction',
        'VoidCallback?',
        '-',
        'Default action handlers.',
        'Callback của action mặc định.',
      ),
    ],
  ),
  'radio': WidgetDoc(
    title: const DocsText(en: 'AppRadio', vi: 'AppRadio'),
    description: const DocsText(
      en: 'Use AppRadio when a user must choose one value from a group.',
      vi: 'Dùng AppRadio khi người dùng chỉ được chọn một giá trị trong nhóm.',
    ),
    quickUse: const DocsText(
      en:
          "String status = 'active';\n\nAppRadio<String>(\n  value: 'active',\n  groupValue: status,\n  label: 'Active',\n  onChanged: (value) => setState(() => status = value!),\n)",
      vi:
          "String trangThai = 'active';\n\nAppRadio<String>(\n  value: 'active',\n  groupValue: trangThai,\n  label: 'Đang hoạt động',\n  onChanged: (value) => setState(() => trangThai = value!),\n)",
    ),
    props: [
      prop(
        'value',
        'T',
        '-',
        'Option value represented by this radio.',
        'Giá trị của option này.',
        required: true,
      ),
      prop(
        'groupValue',
        'T?',
        '-',
        'Current selected group value.',
        'Giá trị đang được chọn của nhóm.',
        required: true,
      ),
      prop(
        'onChanged',
        'ValueChanged<T?>?',
        '-',
        'Receives selected value.',
        'Nhận giá trị được chọn.',
      ),
      prop(
        'size',
        'AppRadioSize?',
        'medium',
        'Visual size.',
        'Kích thước hiển thị.',
      ),
      prop(
        'variant',
        'AppRadioVariant?',
        'standard',
        'standard or boxed.',
        'standard hoặc boxed.',
      ),
      prop(
        'label / labelWidget',
        'String? / Widget?',
        '-',
        'Text label or custom label.',
        'Label text hoặc widget tùy biến.',
      ),
      prop(
        'labelPosition',
        'AppRadioLabelPosition?',
        'right',
        'Places label left or right.',
        'Đặt label bên trái hoặc phải.',
      ),
      prop(
        'isDisabled / isReadOnly',
        'bool?',
        'false',
        'Blocks or limits interaction.',
        'Chặn hoặc giới hạn tương tác.',
      ),
    ],
  ),
  'switch': WidgetDoc(
    title: const DocsText(en: 'AppSwitch', vi: 'AppSwitch'),
    description: const DocsText(
      en: 'Use AppSwitch for immediate on/off settings and preferences.',
      vi: 'Dùng AppSwitch cho cài đặt bật/tắt hoặc tùy chọn có hiệu lực nhanh.',
    ),
    quickUse: const DocsText(
      en:
          "bool enabled = true;\n\nAppSwitch(\n  value: enabled,\n  label: 'Enable notifications',\n  onChanged: (value) => setState(() => enabled = value),\n)",
      vi:
          "bool bat = true;\n\nAppSwitch(\n  value: bat,\n  label: 'Bật thông báo',\n  onChanged: (value) => setState(() => bat = value),\n)",
    ),
    props: [
      prop(
        'value',
        'bool',
        '-',
        'Current on/off state.',
        'Trạng thái bật/tắt hiện tại.',
        required: true,
      ),
      prop(
        'onChanged',
        'ValueChanged<bool>?',
        '-',
        'Receives the next state.',
        'Nhận trạng thái tiếp theo.',
      ),
      prop(
        'size',
        'AppSwitchSize?',
        'medium',
        'Visual switch size.',
        'Kích thước switch.',
      ),
      prop(
        'label / labelWidget',
        'String? / Widget?',
        '-',
        'Text label or custom label.',
        'Label text hoặc widget tùy biến.',
      ),
      prop(
        'labelPosition',
        'AppSwitchLabelPosition?',
        'right',
        'Places label left or right.',
        'Đặt label bên trái hoặc phải.',
      ),
      prop(
        'isDisabled / isReadOnly',
        'bool?',
        'false',
        'Blocks or limits interaction.',
        'Chặn hoặc giới hạn tương tác.',
      ),
      prop(
        'track/thumb colors',
        'Color?',
        '-',
        'Overrides active, inactive, and disabled colors.',
        'Ghi đè màu track/thumb theo trạng thái.',
      ),
    ],
  ),
};

class TokensScreen extends StatelessWidget {
  const TokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Design Tokens', vi: 'Design Tokens'),
      description: const DocsText(
        en:
            'Token screens separate foundations from widgets so consumers can copy stable names for theme, spacing, typography, radius, elevation, and responsive work.',
        vi:
            'Màn hình tokens tách nền tảng khỏi widget để người dùng copy tên ổn định cho theme, spacing, typography, radius, elevation và responsive.',
      ),
      children: const [
        _ColorTokenSection(),
        SizedBox(height: SpacingTokens.gapL),
        _ValueTokenSection(
          title: DocsText(en: 'Spacing', vi: 'Spacing'),
          code: 'SpacingTokens.paddingM',
          items: [
            ('insetDense', '8'),
            ('insetDefault', '12'),
            ('insetRelaxed', '16'),
            ('spaceXS', '4'),
            ('spaceS', '8'),
            ('spaceM', '12'),
            ('spaceL', '16'),
            ('spaceXL', '24'),
            ('space2XL', '32'),
            ('gapS', '8'),
            ('gapM', '12'),
            ('gapL', '16'),
            ('gapXL', '24'),
          ],
        ),
        SizedBox(height: SpacingTokens.gapL),
        _ValueTokenSection(
          title: DocsText(en: 'Radius', vi: 'Radius'),
          code: 'RadiusTokens.radiusL',
          items: [
            ('radiusXS', '2'),
            ('radiusS', '4'),
            ('radiusM', '6'),
            ('radiusL', '8'),
            ('radiusXL', '10'),
          ],
        ),
        SizedBox(height: SpacingTokens.gapL),
        _ValueTokenSection(
          title: DocsText(en: 'Typography', vi: 'Typography'),
          code: 'AppText(text: "Title", size: AppTextSize.heading4Bold)',
          items: [
            ('bodyXS', '12 / 16'),
            ('bodyS', '14 / 20'),
            ('bodyM', '16 / 22'),
            ('bodyL', '18 / 24'),
            ('bodyXL', '20 / 28'),
            ('heading4', '24 / 30'),
            ('heading3', '36 / 44'),
            ('heading2', '48 / 54'),
            ('heading1', '64 / 76'),
          ],
        ),
        SizedBox(height: SpacingTokens.gapL),
        _ValueTokenSection(
          title: DocsText(
            en: 'Component and icon sizes',
            vi: 'Kích thước component và icon',
          ),
          code: 'ComponentSizeTokens.componentM',
          items: [
            ('componentXs', '16'),
            ('componentSm', '24'),
            ('componentM', '32'),
            ('componentL', '40'),
            ('componentXl', '48'),
            ('iconSizeS', '16'),
            ('iconSizeM', '20'),
            ('iconSizeL', '24'),
            ('iconSizeXL', '28'),
          ],
        ),
        SizedBox(height: SpacingTokens.gapL),
        _ValueTokenSection(
          title: DocsText(
            en: 'Elevation, breakpoints, z-index',
            vi: 'Elevation, breakpoints, z-index',
          ),
          code: 'BoxShadowTokens.boxShadowTertiary',
          items: [
            ('boxShadow', 'primary elevation list'),
            ('boxShadowTertiary', 'subtle panel shadow'),
            ('screenXs', '390'),
            ('screenMd', '740'),
            ('screenXl', '1280'),
            ('zIndexModal', '2'),
            ('zIndexTooltip', '3'),
          ],
        ),
      ],
    );
  }
}

class _ColorTokenSection extends StatelessWidget {
  const _ColorTokenSection();

  @override
  Widget build(BuildContext context) {
    const colors = [
      ('primaryDefault', ColorTokens.primaryDefault),
      ('primaryHover', ColorTokens.primaryHover),
      ('primaryBg', ColorTokens.primaryBg),
      ('successDefault', ColorTokens.successDefault),
      ('successBg', ColorTokens.successBg),
      ('warningDefault', ColorTokens.warningDefault),
      ('warningBg', ColorTokens.warningBg),
      ('dangerDefault', ColorTokens.dangerDefault),
      ('dangerBg', ColorTokens.dangerBg),
      ('textDefault', ColorTokens.textDefault),
      ('textDescription', ColorTokens.textDescription),
      ('borderDefault', ColorTokens.borderDefault),
      ('bgElevated', ColorTokens.bgElevated),
      ('bgLayout', ColorTokens.bgLayout),
    ];

    return ExampleSection(
      title: const DocsText(en: 'Color', vi: 'Color'),
      description: const DocsText(
        en:
            'Use semantic color tokens first, then palette colors only for new foundation work.',
        vi:
            'Ưu tiên dùng semantic color token, chỉ dùng palette khi mở rộng foundation.',
      ),
      child: Wrap(
        spacing: SpacingTokens.gapM,
        runSpacing: SpacingTokens.gapM,
        children:
            colors
                .map(
                  (entry) => SizedBox(
                    width: 180,
                    child: _ColorSwatch(name: entry.$1, color: entry.$2),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorSwatch({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderDefault),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                border: Border.all(color: ColorTokens.borderSecondary),
              ),
            ),
            const SizedBox(height: SpacingTokens.gapS),
            AppText(
              text: 'ColorTokens.$name',
              size: AppTextSize.bodySBold,
              color: ColorTokens.textDefault,
            ),
            AppText(
              text: hex,
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDescription,
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueTokenSection extends StatelessWidget {
  final DocsText title;
  final String code;
  final List<(String, String)> items;

  const _ValueTokenSection({
    required this.title,
    required this.code,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return ExampleSection(
      title: title,
      description: DocsText(en: 'Quick use: $code', vi: 'Dùng nhanh: $code'),
      child: Wrap(
        spacing: SpacingTokens.gapM,
        runSpacing: SpacingTokens.gapM,
        children:
            items
                .map(
                  (entry) => Container(
                    width: 220,
                    padding: const EdgeInsets.all(SpacingTokens.paddingM),
                    decoration: BoxDecoration(
                      color: ColorTokens.fillTertiary,
                      borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
                      border: Border.all(color: ColorTokens.borderSecondary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: entry.$1,
                          size: AppTextSize.bodyMBold,
                          color: ColorTokens.textDefault,
                        ),
                        const SizedBox(height: SpacingTokens.gapXS),
                        AppText(
                          text:
                              language == DocsLanguage.en
                                  ? 'Value: ${entry.$2}'
                                  : 'Giá trị: ${entry.$2}',
                          size: AppTextSize.bodySRegular,
                          color: ColorTokens.textDescription,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
