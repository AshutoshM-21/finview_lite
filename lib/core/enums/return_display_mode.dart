/// Controls whether holding cards show gain/loss as amount or percentage.
enum ReturnDisplayMode {
  amount,
  percentage;

  String get label {
    switch (this) {
      case ReturnDisplayMode.amount:
        return 'Amount';
      case ReturnDisplayMode.percentage:
        return 'Percentage';
    }
  }
}
