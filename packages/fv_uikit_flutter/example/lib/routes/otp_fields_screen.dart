import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

import 'docs.dart';

class OtpFieldsScreen extends StatefulWidget {
  const OtpFieldsScreen({super.key});

  @override
  State<OtpFieldsScreen> createState() => _OtpFieldsScreenState();
}

class _OtpFieldsScreenState extends State<OtpFieldsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _otpValue = '';
  String _completedValue = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DocsScaffold(
      title: const DocsText(en: 'OTP Field', vi: 'OTP Field'),
      description: const DocsText(
        en:
            'One-time password input with separated digit cells, numeric sanitizing, paste support, and completion callback.',
        vi:
            'Ô nhập mã OTP với các cell tách biệt, tự lọc số, hỗ trợ paste và callback khi nhập đủ mã.',
      ),
      doc: widgetDocFor('otpField'),
      children: [
        ExampleSection(
          title: const DocsText(en: 'Live example', vi: 'Ví dụ trực tiếp'),
          description: const DocsText(
            en: 'Tap the field, type or paste a 6-digit OTP.',
            vi: 'Chạm vào field rồi nhập hoặc paste mã OTP 6 chữ số.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppOtpField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {
                    _otpValue = value;
                  });
                },
                onCompleted: (value) {
                  setState(() {
                    _completedValue = value;
                  });
                },
              ),
              const SizedBox(height: SpacingTokens.gapM),
              AppText(
                text: 'Current OTP: ${_otpValue.isEmpty ? '-' : _otpValue}',
                size: AppTextSize.bodyMRegular,
                color: ColorTokens.textDefault,
              ),
              const SizedBox(height: SpacingTokens.gapS),
              AppText(
                text:
                    'Completed OTP: ${_completedValue.isEmpty ? '-' : _completedValue}',
                size: AppTextSize.bodyMRegular,
                color: ColorTokens.textDescription,
              ),
            ],
          ),
        ),
        const SizedBox(height: SpacingTokens.gapL),
        ExampleSection(
          title: const DocsText(
            en: 'Disabled state',
            vi: 'Trạng thái disabled',
          ),
          child: const AppOtpField(isDisabled: true),
        ),
      ],
    );
  }
}
