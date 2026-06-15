import 'package:flutter/material.dart';

/// [AppTableRow] represents a data row configuration in [AppTable].
class AppTableRow {
  /// The list of cell widgets in this row.
  final List<Widget> cells;

  /// Called when the row is tapped.
  final VoidCallback? onTap;

  /// Whether this row is currently selected and highlighted.
  final bool isSelected;

  const AppTableRow({
    required this.cells,
    this.onTap,
    this.isSelected = false,
  });
}
