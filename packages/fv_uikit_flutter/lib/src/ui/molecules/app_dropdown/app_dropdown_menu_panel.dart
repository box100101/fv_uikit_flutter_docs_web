import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';
import 'package:fv_uikit_flutter/src/ui/molecules/app_dropdown/app_dropdown_config.dart';

class AppDropdownMenuPanel extends StatelessWidget {
  final double menuMaxHeight;
  final bool opensAbove;
  final Widget? searchField;
  final Widget body;

  const AppDropdownMenuPanel({
    super.key,
    required this.menuMaxHeight,
    required this.opensAbove,
    required this.searchField,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        SpacingTokens.paddingM,
        opensAbove ? SpacingTokens.paddingM : 0,
        SpacingTokens.paddingM,
        opensAbove ? 0 : SpacingTokens.paddingM,
      ),
      decoration: BoxDecoration(
        color: ColorTokens.white,
        borderRadius:
            opensAbove
                ? AppDropdownTokens.topBorderRadius
                : AppDropdownTokens.bottomBorderRadius,
        border: Border(
          top:
              opensAbove
                  ? const BorderSide(color: ColorTokens.borderDefault)
                  : BorderSide.none,
          left: const BorderSide(color: ColorTokens.borderDefault),
          right: const BorderSide(color: ColorTokens.borderDefault),
          bottom:
              opensAbove
                  ? BorderSide.none
                  : const BorderSide(color: ColorTokens.borderDefault),
        ),
        boxShadow: null,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: menuMaxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchField != null) ...[
              searchField!,
              const SizedBox(height: SpacingTokens.gapS),
            ],
            body,
          ],
        ),
      ),
    );
  }
}
