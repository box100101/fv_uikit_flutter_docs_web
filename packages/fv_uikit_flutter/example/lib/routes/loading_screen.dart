import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Loading', vi: 'Loading'),
      description: const DocsText(
        en:
            'Use AppLoadingSpinner for compact busy states inside buttons, dropdowns, cards, and asynchronous sections.',
        vi:
            'Dùng AppLoadingSpinner cho các trạng thái bận gọn nhẹ trong button, dropdown, card và các vùng tải dữ liệu bất đồng bộ.',
      ),
      doc: widgetDocFor('loading'),
      children: const [
        ExampleSection(
          title: DocsText(en: 'Default', vi: 'Mặc định'),
          description: DocsText(
            en: 'Matches the project token size and primary color.',
            vi: 'Dùng size token và màu primary mặc định của dự án.',
          ),
          child: _DefaultLoadingExample(),
        ),
        SizedBox(height: SpacingTokens.gapL),
        ExampleSection(
          title: DocsText(en: 'Sizes and colors', vi: 'Size và màu sắc'),
          description: DocsText(
            en:
                'Scale the spinner to fit inline, section, or emphasis use cases.',
            vi:
                'Tăng giảm spinner để dùng inline, theo section hoặc nhấn mạnh trạng thái tải.',
          ),
          child: _LoadingVariantsExample(),
        ),
        SizedBox(height: SpacingTokens.gapL),
        ExampleSection(
          title: DocsText(en: 'In a surface', vi: 'Trong một khối nội dung'),
          description: DocsText(
            en: 'A common pattern for loading content in cards or empty states.',
            vi: 'Mẫu hay dùng khi tải dữ liệu trong card hoặc trạng thái rỗng.',
          ),
          child: _LoadingSurfaceExample(),
        ),
      ],
    );
  }
}

class _DefaultLoadingExample extends StatelessWidget {
  const _DefaultLoadingExample();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoadingSpinner());
  }
}

class _LoadingVariantsExample extends StatelessWidget {
  const _LoadingVariantsExample();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppLoadingSpinner(size: IconSizeTokens.iconSizeS),
        AppLoadingSpinner(
          size: IconSizeTokens.iconSizeL,
          color: ColorTokens.warningDefault,
        ),
        AppLoadingSpinner(
          size: IconSizeTokens.iconSize2XL,
          strokeWidth: 3,
          color: ColorTokens.successDefault,
        ),
      ],
    );
  }
}

class _LoadingSurfaceExample extends StatelessWidget {
  const _LoadingSurfaceExample();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius: BorderRadius.circular(RadiusTokens.radiusL),
        border: Border.all(color: ColorTokens.borderSecondary),
      ),
      child: const Padding(
        padding: EdgeInsets.all(SpacingTokens.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingSpinner(size: IconSizeTokens.iconSize2XL, strokeWidth: 3),
            SizedBox(height: SpacingTokens.gapM),
            AppText(
              text: 'Đang tải dữ liệu đơn hàng...',
              size: AppTextSize.bodyMRegular,
              color: ColorTokens.textLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
