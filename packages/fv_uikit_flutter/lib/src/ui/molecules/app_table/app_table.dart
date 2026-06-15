import 'package:flutter/material.dart';
import 'package:fv_uikit_flutter/fv_uikit_flutter.dart';

/// [AppTable] is a molecule widget that builds a double-scrollable table
/// (horizontal scrolling for wide columns and internal vertical scrolling for data)
/// with a sticky header.
class AppTable extends StatelessWidget {
  /// Cấu hình chiều rộng của từng cột trong bảng.
  final Map<int, TableColumnWidth> columnWidths;

  /// Danh sách các widget tiêu đề của bảng.
  final List<Widget> headerCells;

  /// Danh sách các dòng dữ liệu của bảng.
  final List<AppTableRow> rows;

  /// Chiều cao tối đa của bảng.
  final double? maxHeight;

  /// Màu nền của bảng.
  final Color? backgroundColor;

  /// Bo góc của bảng.
  final BorderRadiusGeometry? borderRadius;

  /// Đường viền của bảng.
  final BoxBorder? border;

  /// Khoảng đệm (padding) của toàn bộ bảng.
  final EdgeInsetsGeometry? padding;

  /// Khoảng đệm (padding) của từng ô dữ liệu.
  final EdgeInsetsGeometry? cellPadding;

  const AppTable({
    super.key,
    required this.columnWidths,
    required this.headerCells,
    required this.rows,
    this.maxHeight,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.cellPadding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCellPadding = cellPadding ?? const EdgeInsets.symmetric(
      horizontal: SpacingTokens.spaceM,
      vertical: SpacingTokens.spaceM,
    );

    return AppTableContainer(
      maxHeight: maxHeight,
      isVerticalScrollable: false,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      border: border,
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Table (Sticky)
          Container(
            decoration: BoxDecoration(
              color: ColorTokens.fillTertiary,
              border: const Border(
                bottom: BorderSide(
                  color: ColorTokens.borderSecondary,
                  width: 1,
                ),
              ),
            ),
            child: Table(
              columnWidths: columnWidths,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: headerCells.map((cell) {
                    return Padding(
                      padding: effectiveCellPadding,
                      child: cell,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Body Table (Scrollable)
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                columnWidths: columnWidths,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: rows.map((row) {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: row.isSelected ? ColorTokens.primaryBg : null,
                      border: const Border(
                        bottom: BorderSide(
                          color: ColorTokens.borderSecondary,
                          width: 0.5,
                        ),
                      ),
                    ),
                    children: row.cells.map((cell) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: row.onTap,
                        child: Padding(
                          padding: effectiveCellPadding,
                          child: cell,
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
