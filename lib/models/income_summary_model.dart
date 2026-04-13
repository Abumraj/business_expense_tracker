class IncomeSummary {
  const IncomeSummary({
    required this.totalIncome,
    required this.monthlyIncome,
    required this.pendingIncome,
  });

  final double totalIncome;
  final double monthlyIncome;
  final double pendingIncome;

  factory IncomeSummary.fromJson(Map<String, dynamic> json) {
    return IncomeSummary(
      totalIncome: parseDynamic(json['totalIncome']),
      monthlyIncome: parseDynamic(json['monthlyIncome']),
      pendingIncome: parseDynamic(json['pendingIncome']),
    );
  }

  static double parseDynamic(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'monthlyIncome': monthlyIncome,
      'pendingIncome': pendingIncome,
    };
  }

  @override
  String toString() {
    return 'IncomeSummary(totalIncome: $totalIncome, monthlyIncome: $monthlyIncome, pendingIncome: $pendingIncome)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IncomeSummary &&
        other.totalIncome == totalIncome &&
        other.monthlyIncome == monthlyIncome &&
        other.pendingIncome == pendingIncome;
  }

  @override
  int get hashCode {
    return totalIncome.hashCode ^ monthlyIncome.hashCode ^ pendingIncome.hashCode;
  }
}
