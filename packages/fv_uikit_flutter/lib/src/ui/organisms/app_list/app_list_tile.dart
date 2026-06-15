import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// A single item widget designed for use inside list widgets.
///
/// Provides a consistent layout with optional [leading], [trailing],
/// [title], [subtitle], [description], and [badge] slots. Reuses
/// [AppText] for typography and [AppBadge] for badge rendering.
///
/// ```dart
/// AppListTile(
///   title: 'Order #1234',
///   subtitle: 'Pending',
///   leading: Icon(Icons.shopping_bag),
///   trailing: AppBadge(text: 'New', variant: AppBadgeVariant.info),
///   onTap: () => navigateToDetail(),
/// )
/// ```
class AppListTile extends StatelessWidget {
  // -- Content ---------------------------------------------------------------

  /// Primary text of the tile.
  final String title;

  /// Secondary text rendered below the [title].
  final String? subtitle;

  /// Tertiary / description text rendered below the [subtitle].
  final String? description;

  // -- Slots -----------------------------------------------------------------

  /// Widget placed at the start of the tile (e.g. avatar, icon, thumbnail).
  final Widget? leading;

  /// Widget placed at the end of the tile (e.g. arrow, badge, switch).
  final Widget? trailing;

  /// Optional badge positioned at the top-end of [leading].
  final Widget? badge;

  // -- Sizing ----------------------------------------------------------------

  /// Controls padding, font sizes, and minimum height.
  final AppListTileSize size;

  // -- Interaction -----------------------------------------------------------

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Called when the tile is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether this tile is visually marked as selected.
  final bool isSelected;

  /// Whether interaction is disabled.
  final bool isDisabled;

  // -- Customization ---------------------------------------------------------

  /// Override the tile background color.
  final Color? backgroundColor;

  /// Override content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Override border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to show a bottom border. Defaults to `false`.
  final bool showBottomBorder;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.trailing,
    this.badge,
    this.size = AppListTileSize.medium,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.contentPadding,
    this.borderRadius,
    this.showBottomBorder = false,
  });

  AppListTileMetrics get _metrics => AppListTileMetrics.fromSize(size);

  Color _resolveBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (isDisabled) return ColorTokens.bgContainerDisabled;
    if (isSelected) return ColorTokens.primaryBg;
    return ColorTokens.transparent;
  }

  Color _resolveTitleColor() {
    if (isDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textDefault;
  }

  Color _resolveSubtitleColor() {
    if (isDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textSecondary;
  }

  Color _resolveDescriptionColor() {
    if (isDisabled) return ColorTokens.textDisabled;
    return ColorTokens.textDescription;
  }

  Widget _buildLeading(AppListTileMetrics metrics) {
    final leadingWidget = SizedBox.square(
      dimension: metrics.leadingSize,
      child: Center(child: leading),
    );

    if (badge == null) return leadingWidget;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        leadingWidget,
        Positioned(top: -4, right: -4, child: badge!),
      ],
    );
  }

  Widget _buildContent(AppListTileMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          text: title,
          size: metrics.titleTextSize,
          color: _resolveTitleColor(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: SpacingTokens.spaceXS),
          AppText(
            text: subtitle!,
            size: metrics.subtitleTextSize,
            color: _resolveSubtitleColor(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (description != null) ...[
          const SizedBox(height: SpacingTokens.spaceXS),
          AppText(
            text: description!,
            size: metrics.descriptionTextSize,
            color: _resolveDescriptionColor(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _metrics;
    final resolvedPadding =
        contentPadding ??
        EdgeInsets.symmetric(
          horizontal: metrics.horizontalPadding,
          vertical: metrics.verticalPadding,
        );
    final resolvedBorderRadius =
        borderRadius ?? RadiusTokens.radiusMdBorderRadius;

    Widget tile = Container(
      constraints: BoxConstraints(minHeight: metrics.minHeight),
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(),
        borderRadius: resolvedBorderRadius,
        border:
            showBottomBorder
                ? const Border(
                  bottom: BorderSide(color: ColorTokens.borderSecondary),
                )
                : (isSelected
                    ? Border.all(color: ColorTokens.primaryDefault)
                    : null),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            _buildLeading(metrics),
            SizedBox(width: metrics.leadingTrailingGap),
          ],
          Expanded(child: _buildContent(metrics)),
          if (trailing != null) ...[
            SizedBox(width: metrics.leadingTrailingGap),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null || onLongPress != null) {
      tile = Material(
        color: ColorTokens.transparent,
        child: InkWell(
          borderRadius:
              resolvedBorderRadius is BorderRadius
                  ? resolvedBorderRadius
                  : BorderRadius.circular(RadiusTokens.radiusM),
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          child: tile,
        ),
      );
    }

    return Opacity(opacity: isDisabled ? 0.5 : 1.0, child: tile);
  }
}
