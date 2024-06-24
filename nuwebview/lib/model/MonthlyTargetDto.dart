class MonthlyTargetDto {
  late String factory;
  late int year;
  late int month;
  late double income;
  late int workingDays;

  MonthlyTargetDto({
    required this.factory,
    required this.year,
    required this.month,
    required this.income,
    required this.workingDays,
  });

  factory MonthlyTargetDto.fromJson(Map<String, dynamic> json) {
    return MonthlyTargetDto(
      factory: json['branch_id'] as String,
      year: json['inc_year'] as int,
      month: json['inc_month'] as int,
      income: json['income'].toDouble(),
      workingDays: json['w_days'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = factory;
    data['inc_year'] = year;
    data['inc_month'] = month;
    data['income'] = income;
    data['w_days'] = workingDays;
    return data;
  }
}