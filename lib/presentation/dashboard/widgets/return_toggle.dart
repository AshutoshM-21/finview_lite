import 'package:flutter/material.dart';

import '../../../core/enums/return_display_mode.dart';

/// Segmented control to switch holding gain/loss display between amount and percentage.
class ReturnToggle extends StatelessWidget {
  final ReturnDisplayMode selectedMode;
  final ValueChanged<ReturnDisplayMode> onChanged;

  const ReturnToggle({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ReturnDisplayMode>(
      segments: ReturnDisplayMode.values
          .map(
            (mode) => ButtonSegment<ReturnDisplayMode>(
              value: mode,
              label: Text(mode.label),
            ),
          )
          .toList(),
      selected: {selectedMode},
      onSelectionChanged: (selection) => onChanged(selection.first),
      showSelectedIcon: false,
    );
  }
}
