import '../../data/models/holding_model.dart';

/// Available sort criteria for the holdings list.
enum HoldingSortOption {
  name,
  currentValue,
  gain;

  String get label {
    switch (this) {
      case HoldingSortOption.name:
        return 'Name';
      case HoldingSortOption.currentValue:
        return 'Current Value';
      case HoldingSortOption.gain:
        return 'Gain';
    }
  }

  /// Returns a sorted copy of [holdings] in descending order.
  List<HoldingModel> sort(List<HoldingModel> holdings) {
    final sorted = List<HoldingModel>.from(holdings);
    switch (this) {
      case HoldingSortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case HoldingSortOption.currentValue:
        sorted.sort((a, b) => b.currentValue.compareTo(a.currentValue));
      case HoldingSortOption.gain:
        sorted.sort((a, b) => b.gainLoss.compareTo(a.gainLoss));
    }
    return sorted;
  }
}
