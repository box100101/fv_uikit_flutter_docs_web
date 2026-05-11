import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

void _logPressed() => debugPrint('pressed');

class ButtonsScreen extends StatelessWidget {
  ButtonsScreen({super.key});

  final buttons = [
    AppButton(
      text: 'Button size xSmall',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      size: AppButtonSize.xSmall,
    ),
    AppButton(
      text: 'Button size small',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      size: AppButtonSize.small,
    ),
    AppButton(
      text: 'Button size medium',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      size: AppButtonSize.medium,
    ),
    AppButton(
      text: 'Button size large',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      size: AppButtonSize.large,
    ),
    AppButton(
      text: 'Button size xLarge',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      size: AppButtonSize.xLarge,
    ),
    AppButton(
      variant: AppButtonVariant.primary,
      text: 'Button primary',
      onPressed: _logPressed,
    ),
    AppButton(
      text: 'Button outline',
      variant: AppButtonVariant.outline,
      onPressed: _logPressed,
    ),
    AppButton(text: 'Button default', onPressed: _logPressed),
    AppButton(
      text: 'Button dash',
      variant: AppButtonVariant.dash,
      onPressed: _logPressed,
    ),
    AppButton(
      variant: AppButtonVariant.danger,
      text: 'Button danger',
      onPressed: _logPressed,
    ),
    AppButton(
      variant: AppButtonVariant.text,
      text: 'Button text',
      onPressed: _logPressed,
    ),
    AppButton(
      variant: AppButtonVariant.link,
      text: 'Button link',
      onPressed: _logPressed,
    ),
    AppButton(
      variant: AppButtonVariant.warning,
      text: 'Button warning',
      onPressed: _logPressed,
    ),
    AppButton(
      variant: AppButtonVariant.primary,
      text: 'Button disabled',
      onPressed: _logPressed,
      isDisabled: true,
    ),
    AppButton(
      text: 'Button loading',
      variant: AppButtonVariant.primary,
      isLoading: true,
      onPressed: _logPressed,
    ),
    AppButton(
      text: 'Button icon left',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      iconLeft: Icon(Icons.person, color: ColorTokens.white),
    ),
    AppButton(
      text: 'Button icon right',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      iconRight: Icon(Icons.person, color: ColorTokens.white),
    ),
    AppButton(
      text: 'Button full width',
      variant: AppButtonVariant.primary,
      onPressed: _logPressed,
      isFullWidth: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'Buttons', vi: 'Buttons'),
      description: const DocsText(
        en:
            'Ready-made action buttons for primary, secondary, danger, text, link, loading, disabled, icon, and full-width states.',
        vi:
            'Các nút hành động build sẵn cho primary, secondary, danger, text, link, loading, disabled, icon và full-width.',
      ),
      doc: widgetDocFor('button'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live examples', vi: 'Ví dụ trực tiếp'),
          description: const DocsText(
            en:
                'Use this screen to compare sizes, variants, and interaction states before copying a snippet.',
            vi:
                'Dùng màn hình này để so sánh size, variant và trạng thái tương tác trước khi copy snippet.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < buttons.length; index++) ...[
                buttons[index],
                if (index != buttons.length - 1)
                  const SizedBox(height: SpacingTokens.paddingM),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
