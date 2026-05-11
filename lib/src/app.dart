import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs/content.dart';
import 'docs/models.dart';

LocalizedText _t(String en, String vi) => LocalizedText(en: en, vi: vi);

class DocsApp extends StatefulWidget {
  final String? initialRoute;

  const DocsApp({super.key, this.initialRoute});

  @override
  State<DocsApp> createState() => _DocsAppState();
}

class _DocsAppState extends State<DocsApp> {
  final ValueNotifier<DocsLanguage> _language = ValueNotifier(DocsLanguage.vi);

  @override
  void dispose() {
    _language.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DocsLanguageScope(
      notifier: _language,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FV UIKit Docs',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: ColorTokens.backgroundColorExample,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorTokens.primaryDefault,
            brightness: Brightness.light,
          ),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
        ),
        initialRoute: widget.initialRoute ?? '/',
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final route = _normalizeRoute(settings.name ?? '/');

    if (route == '/') {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/'),
        builder: (_) => const HomePage(),
      );
    }

    if (route == '/tokens') {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: '/tokens'),
        builder: (_) => const TokensPage(),
      );
    }

    if (route.startsWith('/widgets/')) {
      final slug = route.replaceFirst('/widgets/', '');
      final entry = widgetDocsBySlug[slug];
      if (entry != null) {
        return MaterialPageRoute<void>(
          settings: RouteSettings(name: route),
          builder: (_) => WidgetDocPage(entry: entry),
        );
      }
    }

    return MaterialPageRoute<void>(
      settings: RouteSettings(name: route),
      builder: (_) => NotFoundPage(route: route),
    );
  }
}

String _normalizeRoute(String route) {
  if (route.isEmpty) return '/';
  final normalized = route.endsWith('/') && route.length > 1
      ? route.substring(0, route.length - 1)
      : route;
  return normalized;
}

class DocsLanguageScope extends InheritedNotifier<ValueNotifier<DocsLanguage>> {
  const DocsLanguageScope({
    super.key,
    required ValueNotifier<DocsLanguage> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ValueNotifier<DocsLanguage> controllerOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DocsLanguageScope>();
    return scope?.notifier ?? _fallback;
  }

  static DocsLanguage languageOf(BuildContext context) {
    return controllerOf(context).value;
  }

  static final ValueNotifier<DocsLanguage> _fallback =
      ValueNotifier(DocsLanguage.vi);
}

class AppShell extends StatelessWidget {
  final String currentRoute;
  final LocalizedText pageTitle;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentRoute,
    required this.pageTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1080;
        final navigation = AppNavigation(currentRoute: currentRoute);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorTokens.primary,
            foregroundColor: ColorTokens.white,
            title: AppText(
              text: pageTitle.resolve(language),
              size: AppTextSize.heading4Bold,
              color: ColorTokens.white,
            ),
            leading: isWide
                ? null
                : Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu),
                      );
                    },
                  ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: SpacingTokens.paddingM),
                child: Center(child: LanguageSwitch()),
              ),
            ],
          ),
          drawer: isWide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: navigation,
                  ),
                ),
          body: SafeArea(
            top: false,
            child: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: 304,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: ColorTokens.borderSecondary),
                        ),
                        color: ColorTokens.white,
                      ),
                      child: navigation,
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth >= 920
                          ? SpacingTokens.paddingL
                          : SpacingTokens.paddingM,
                      vertical: SpacingTokens.paddingL,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DocsLanguageScope.controllerOf(context);

    return ValueListenableBuilder<DocsLanguage>(
      valueListenable: controller,
      builder: (context, language, _) {
        return SegmentedButton<DocsLanguage>(
          segments: const [
            ButtonSegment(value: DocsLanguage.vi, label: Text('VI')),
            ButtonSegment(value: DocsLanguage.en, label: Text('EN')),
          ],
          selected: {language},
          showSelectedIcon: false,
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ColorTokens.primaryBg;
              }
              return ColorTokens.white;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ColorTokens.primaryDefault;
              }
              return ColorTokens.textDefault;
            }),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
          onSelectionChanged: (selection) {
            controller.value = selection.first;
          },
        );
      },
    );
  }
}

class AppNavigation extends StatelessWidget {
  final String currentRoute;

  const AppNavigation({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return ListView(
      padding: const EdgeInsets.all(SpacingTokens.paddingM),
      children: [
        _NavigationHomeTile(currentRoute: currentRoute),
        const SizedBox(height: SpacingTokens.gapL),
        for (final group in navGroups) ...[
          AppText(
            text: group.title.resolve(language),
            size: AppTextSize.bodyLBold,
            color: ColorTokens.textDefault,
          ),
          const SizedBox(height: SpacingTokens.gapXS),
          AppText(
            text: group.description.resolve(language),
            size: AppTextSize.bodySRegular,
            color: ColorTokens.textDescription,
          ),
          const SizedBox(height: SpacingTokens.gapS),
          for (final item in group.items) ...[
            _NavigationTile(
              item: item,
              isActive: currentRoute == item.route,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
          ],
          const SizedBox(height: SpacingTokens.gapL),
        ],
      ],
    );
  }
}

class _NavigationHomeTile extends StatelessWidget {
  final String currentRoute;

  const _NavigationHomeTile({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      onTap: () => Navigator.pushReplacementNamed(context, '/'),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
          color: currentRoute == '/' ? ColorTokens.primaryBg : ColorTokens.fillTertiary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.paddingM),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ColorTokens.primary,
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.widgets_outlined, color: ColorTokens.white),
              ),
              const SizedBox(width: SpacingTokens.gapM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: language == DocsLanguage.en ? 'FV UIKit Docs' : 'FV UIKit Docs',
                      size: AppTextSize.bodyMBold,
                      color: ColorTokens.textDefault,
                    ),
                    const SizedBox(height: SpacingTokens.gapXS),
                    AppText(
                      text: language == DocsLanguage.en
                          ? 'Browse foundations, widgets, and live examples.'
                          : 'Tra cứu foundations, widget và ví dụ chạy thật.',
                      size: AppTextSize.bodySRegular,
                      color: ColorTokens.textDescription,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final NavItem item;
  final bool isActive;

  const _NavigationTile({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      onTap: () => Navigator.pushReplacementNamed(context, item.route),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
          border: Border.all(
            color: isActive ? ColorTokens.primaryDefault : ColorTokens.borderSecondary,
          ),
          color: isActive ? ColorTokens.primaryBg : ColorTokens.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, color: isActive ? ColorTokens.primaryDefault : ColorTokens.iconDefault),
              const SizedBox(width: SpacingTokens.gapS),
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
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return AppShell(
      currentRoute: '/',
      pageTitle: _t('FV UIKit Docs', 'FV UIKit Docs'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHero(
            eyebrow: _t('UIKit Catalog', 'UIKit Catalog'),
            title: _t(
              'Build faster with live docs for every public FV UIKit widget.',
              'Xây nhanh hơn với live docs cho mọi public widget của FV UIKit.',
            ),
            description: _t(
              'This site is intentionally hardcoded around the current package surface so the team can browse real props, quick-start snippets, and working examples without leaving the browser.',
              'Site này được hardcode theo đúng surface hiện tại của package để team tra cứu props thật, snippet dùng nhanh và ví dụ chạy được ngay trên browser.',
            ),
            trailing: Wrap(
              spacing: SpacingTokens.gapM,
              runSpacing: SpacingTokens.gapM,
              children: [
                StatCard(
                  label: language == DocsLanguage.en ? 'Documented widgets' : 'Widget đã document',
                  value: '${widgetDocsBySlug.length}',
                ),
                StatCard(
                  label: language == DocsLanguage.en ? 'Token groups' : 'Nhóm token',
                  value: '${tokenCategories.length + 1}',
                ),
                StatCard(
                  label: language == DocsLanguage.en ? 'Bilingual content' : 'Nội dung song ngữ',
                  value: 'VI + EN',
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          for (final group in navGroups) ...[
            SectionCard(
              title: group.title,
              description: group.description,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 760;
                  final width = isWide
                      ? (constraints.maxWidth - SpacingTokens.gapM) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: SpacingTokens.gapM,
                    runSpacing: SpacingTokens.gapM,
                    children: [
                      for (final item in group.items)
                        SizedBox(
                          width: width,
                          child: CatalogCard(item: item),
                        ),
                    ],
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

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: '/tokens',
      pageTitle: _t('Design Tokens', 'Design Tokens'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHero(
            eyebrow: _t('Foundations', 'Nền tảng'),
            title: _t(
              'Shared tokens keep every widget aligned on color, spacing, type, and layering.',
              'Token dùng chung giúp mọi widget đồng bộ về màu, spacing, typography và layering.',
            ),
            description: _t(
              'Copy stable token names here before branching into widget-specific docs. These foundations are the safest entry point for theming and layout work.',
              'Hãy copy các tên token ổn định ở đây trước khi đi sâu vào docs của từng widget. Đây là điểm bắt đầu an toàn nhất cho theming và layout.',
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          SectionCard(
            title: _t('Color', 'Color'),
            description: _t(
              'Prefer semantic color tokens first; fall back to palette work only when extending the design system.',
              'Ưu tiên semantic color token trước; chỉ fallback sang palette khi mở rộng design system.',
            ),
            child: Wrap(
              spacing: SpacingTokens.gapM,
              runSpacing: SpacingTokens.gapM,
              children: [
                for (final token in colorTokens)
                  SizedBox(
                    width: 180,
                    child: ColorTokenCard(token: token),
                  ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          for (final category in tokenCategories) ...[
            SectionCard(
              title: category.title,
              description: category.description,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InlineCodeLabel(code: category.quickUse),
                  const SizedBox(height: SpacingTokens.gapM),
                  Wrap(
                    spacing: SpacingTokens.gapM,
                    runSpacing: SpacingTokens.gapM,
                    children: [
                      for (final item in category.items)
                        SizedBox(
                          width: 220,
                          child: ValueTokenCard(item: item),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SpacingTokens.gapL),
          ],
        ],
      ),
    );
  }
}

class WidgetDocPage extends StatefulWidget {
  final WidgetDocEntry entry;

  const WidgetDocPage({super.key, required this.entry});

  @override
  State<WidgetDocPage> createState() => _WidgetDocPageState();
}

class _WidgetDocPageState extends State<WidgetDocPage> {
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _propsKey = GlobalKey();
  final GlobalKey _examplesKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return AppShell(
      currentRoute: '/widgets/${entry.slug}',
      pageTitle: entry.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHero(
            eyebrow: _t('Widget Reference', 'Widget Reference'),
            title: entry.title,
            description: entry.summary,
          ),
          const SizedBox(height: SpacingTokens.gapL),
          Wrap(
            spacing: SpacingTokens.gapS,
            runSpacing: SpacingTokens.gapS,
            children: [
              AnchorChip(
                label: _t('Overview', 'Tổng quan'),
                onTap: () => _scrollTo(_overviewKey),
              ),
              AnchorChip(
                label: _t('Props', 'Props'),
                onTap: () => _scrollTo(_propsKey),
              ),
              AnchorChip(
                label: _t('Examples', 'Ví dụ'),
                onTap: () => _scrollTo(_examplesKey),
              ),
            ],
          ),
          const SizedBox(height: SpacingTokens.gapL),
          KeyedSubtree(
            key: _overviewKey,
            child: SectionCard(
              title: _t('Usage guide', 'Hướng dẫn sử dụng'),
              description: entry.summary,
              child: CodeBlock(code: entry.quickStart),
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          KeyedSubtree(
            key: _propsKey,
            child: SectionCard(
              title: _t('Props reference', 'Bảng chú thích props'),
              description: _t(
                'Every constructor parameter documented from the current public API.',
                'Mọi tham số constructor đều được chú thích theo public API hiện tại.',
              ),
              child: PropsTable(props: entry.props),
            ),
          ),
          const SizedBox(height: SpacingTokens.gapL),
          KeyedSubtree(
            key: _examplesKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final example in entry.examples) ...[
                  ExampleCard(example: example),
                  const SizedBox(height: SpacingTokens.gapL),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  final String route;

  const NotFoundPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: route,
      pageTitle: _t('Page not found', 'Không tìm thấy trang'),
      child: SectionCard(
        title: _t('Unknown route', 'Route không tồn tại'),
        description: _t(
          'The requested route is not part of this docs site.',
          'Route được yêu cầu không thuộc docs site này.',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InlineCodeLabel(code: route),
            const SizedBox(height: SpacingTokens.gapM),
            AppButton(
              text: 'Back to home',
              variant: AppButtonVariant.primary,
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientHero extends StatelessWidget {
  final LocalizedText eyebrow;
  final LocalizedText title;
  final LocalizedText description;
  final Widget? trailing;

  const GradientHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C5B7E),
            Color(0xFF1597A0),
            Color(0xFFF2C572),
          ],
        ),
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        boxShadow: BoxShadowTokens.boxShadowTertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingL),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;

            return isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _HeroCopy(eyebrow: eyebrow, title: title, description: description, language: language)),
                      if (trailing != null) ...[
                        const SizedBox(width: SpacingTokens.gapL),
                        SizedBox(width: 320, child: trailing!),
                      ],
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCopy(eyebrow: eyebrow, title: title, description: description, language: language),
                      if (trailing != null) ...[
                        const SizedBox(height: SpacingTokens.gapL),
                        trailing!,
                      ],
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final LocalizedText eyebrow;
  final LocalizedText title;
  final LocalizedText description;
  final DocsLanguage language;

  const _HeroCopy({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.paddingS,
            vertical: SpacingTokens.paddingXS,
          ),
          decoration: BoxDecoration(
            color: ColorTokens.white.withAlpha(36),
            borderRadius: BorderRadius.circular(RadiusTokens.radiusXL),
          ),
          child: AppText(
            text: eyebrow.resolve(language),
            size: AppTextSize.bodySBold,
            color: ColorTokens.white,
          ),
        ),
        const SizedBox(height: SpacingTokens.gapM),
        AppText(
          text: title.resolve(language),
          size: AppTextSize.heading4Bold,
          color: ColorTokens.white,
        ),
        const SizedBox(height: SpacingTokens.gapM),
        AppText(
          text: description.resolve(language),
          size: AppTextSize.bodyMRegular,
          color: const Color(0xFFF7FAFC),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white.withAlpha(28),
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.white.withAlpha(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: value, size: AppTextSize.heading4Bold, color: ColorTokens.white),
            const SizedBox(height: SpacingTokens.gapXS),
            AppText(text: label, size: AppTextSize.bodySRegular, color: ColorTokens.white),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final LocalizedText title;
  final LocalizedText description;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
        boxShadow: BoxShadowTokens.boxShadowTertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: title.resolve(language),
              size: AppTextSize.bodyLBold,
              color: ColorTokens.textDefault,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
            AppText(
              text: description.resolve(language),
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDescription,
            ),
            const SizedBox(height: SpacingTokens.gapM),
            child,
          ],
        ),
      ),
    );
  }
}

class CatalogCard extends StatelessWidget {
  final NavItem item;

  const CatalogCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return InkWell(
      borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      onTap: () => Navigator.pushNamed(context, item.route),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
          border: Border.all(color: ColorTokens.borderDefault),
          color: ColorTokens.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpacingTokens.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ColorTokens.primaryBg,
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
                ),
                alignment: Alignment.center,
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

class ColorTokenCard extends StatelessWidget {
  final ColorTokenEntry token;

  const ColorTokenCard({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${token.color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

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
                color: token.color,
                borderRadius: BorderRadius.circular(RadiusTokens.radiusM),
                border: Border.all(color: ColorTokens.borderSecondary),
              ),
            ),
            const SizedBox(height: SpacingTokens.gapS),
            AppText(
              text: 'ColorTokens.${token.name}',
              size: AppTextSize.bodySBold,
              color: ColorTokens.textDefault,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
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

class ValueTokenCard extends StatelessWidget {
  final TokenValueEntry item;

  const ValueTokenCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.fillTertiary,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: item.name,
              size: AppTextSize.bodyMBold,
              color: ColorTokens.textDefault,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
            AppText(
              text: item.value,
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDescription,
            ),
          ],
        ),
      ),
    );
  }
}

class InlineCodeLabel extends StatelessWidget {
  final String code;

  const InlineCodeLabel({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.paddingS,
        vertical: SpacingTokens.paddingXS,
      ),
      decoration: BoxDecoration(
        color: ColorTokens.fillTertiary,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          color: ColorTokens.textDefault,
        ),
      ),
    );
  }
}

class AnchorChip extends StatelessWidget {
  final LocalizedText label;
  final VoidCallback onTap;

  const AnchorChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return ActionChip(
      onPressed: onTap,
      label: Text(label.resolve(language)),
      backgroundColor: ColorTokens.primaryBg,
      labelStyle: const TextStyle(
        color: ColorTokens.primaryDefault,
        fontWeight: FontWeight.w700,
      ),
      side: const BorderSide(color: ColorTokens.primaryDefault),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final LocalizedText code;

  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);
    final resolvedCode = code.resolve(language);

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
              SpacingTokens.paddingM,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    text: language == DocsLanguage.en
                        ? 'Quick copy-paste'
                        : 'Dùng nhanh copy-paste',
                    size: AppTextSize.bodySBold,
                    color: ColorTokens.white,
                  ),
                ),
                IconButton(
                  tooltip: language == DocsLanguage.en ? 'Copy code' : 'Sao chép code',
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: resolvedCode));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          language == DocsLanguage.en
                              ? 'Code copied'
                              : 'Đã sao chép code',
                        ),
                      ),
                    );
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
              resolvedCode,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.45,
                color: Color(0xFFE6EDF3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropsTable extends StatelessWidget {
  final List<PropDocEntry> props;

  const PropsTable({super.key, required this.props});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowColor: WidgetStateProperty.all(ColorTokens.fillTertiary),
        headingTextStyle: const TextStyle(
          color: ColorTokens.textDefault,
          fontWeight: FontWeight.w700,
        ),
        columns: [
          DataColumn(label: Text(language == DocsLanguage.en ? 'Prop' : 'Prop')),
          DataColumn(label: Text(language == DocsLanguage.en ? 'Type' : 'Kiểu')),
          DataColumn(label: Text(language == DocsLanguage.en ? 'Required' : 'Bắt buộc')),
          DataColumn(label: Text(language == DocsLanguage.en ? 'Default' : 'Mặc định')),
          DataColumn(label: Text(language == DocsLanguage.en ? 'Note' : 'Ghi chú')),
        ],
        rows: [
          for (final prop in props)
            DataRow(
              cells: [
                DataCell(Text(prop.name)),
                DataCell(Text(prop.type)),
                DataCell(Text(prop.required ? (language == DocsLanguage.en ? 'Yes' : 'Có') : (language == DocsLanguage.en ? 'No' : 'Không'))),
                DataCell(Text(prop.defaultValue)),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Text(prop.description.resolve(language)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ExampleCard extends StatelessWidget {
  final ExampleDocEntry example;

  const ExampleCard({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    final language = DocsLanguageScope.languageOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
        boxShadow: BoxShadowTokens.boxShadowTertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(SpacingTokens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: example.title.resolve(language),
              size: AppTextSize.bodyLBold,
              color: ColorTokens.textDefault,
            ),
            const SizedBox(height: SpacingTokens.gapXS),
            AppText(
              text: example.description.resolve(language),
              size: AppTextSize.bodySRegular,
              color: ColorTokens.textDescription,
            ),
            const SizedBox(height: SpacingTokens.gapM),
            DecoratedBox(
              decoration: BoxDecoration(
                color: ColorTokens.fillTertiary,
                borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
                border: Border.all(color: ColorTokens.borderSecondary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.paddingL),
                child: example.builder(context),
              ),
            ),
            const SizedBox(height: SpacingTokens.gapM),
            CodeBlock(code: _t(example.code, example.code)),
          ],
        ),
      ),
    );
  }
}
