class EfficiencyIncomeDTO {
  final String date;
  final double totalIncome;
  double cumalative;

  EfficiencyIncomeDTO({
    required this.date,
    required this.totalIncome,
    required this.cumalative
  });

  factory EfficiencyIncomeDTO.fromJson(Map<String, dynamic> json) {
    return EfficiencyIncomeDTO(
      date: json['Date'] ?? '',
      totalIncome: (json['Total Income'] ?? 0.0).toDouble(),
      cumalative: (json['cumalative'] ?? 0.0).toDouble(),
    );
  }
}