import 'package:flutter/material.dart';

import '../../../core/enums/holding_sort_option.dart';

/// Dropdown for selecting holdings list sort criteria.
class SortDropdown extends StatelessWidget {
  final HoldingSortOption selectedOption;
  final ValueChanged<HoldingSortOption> onChanged;

  const SortDropdown({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<HoldingSortOption>(
      value: selectedOption,
      decoration: const InputDecoration(
        labelText: 'Sort by',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      items: HoldingSortOption.values
          .map(
            (option) => DropdownMenuItem<HoldingSortOption>(
              value: option,
              child: Text(option.label),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
