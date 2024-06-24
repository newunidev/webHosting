class EfficiencyDtoSend {
  late DateTime date;
  late String branchId;
  late int lineNo;
  late String style;
  late String poNo;
  late int qty;
  late int mo;
  late int hel;
  late int iron;
  late double smv;
  late double cm;
  late int forecastPcs;
  late double forecastSah;
  late double forecastEff;
  late int actualPcs;
  late double actualSah;
  late double actualEff;
  late double income;



  EfficiencyDtoSend.fromJson(Map<String, dynamic> json) {
    try {
      date = json['date'];
      branchId = json['branch_id'];
      lineNo = json['line_no'];
      style = json['style'];
      poNo = json['po_no'];
      qty = json['qty'];
      mo = json['mo'];
      hel = json['hel'];
      iron = json['iron'];
      smv = json['smv'].toDouble(); // Ensure that 'smv' is treated as a double
      cm = json['cm'].toDouble();   // Ensure that 'cm' is treated as a double
      forecastPcs = json['forcast_pcs'];
      forecastSah = json['forcast_sah'].toDouble(); // Ensure that 'forcast_sah' is treated as a double
      forecastEff = json['forcast_eff'].toDouble(); // Ensure that 'forcast_eff' is treated as a double
      actualPcs = json['actual_pcs'];
      actualSah = json['actual_sah'].toDouble();   // Ensure that 'actual_sah' is treated as a double
      actualEff = json['actual_eff'].toDouble();   // Ensure that 'actual_eff' is treated as a double
      income = json['income'].toDouble();           // Ensure that 'income' is treated as a double
    } catch (e) {
      // Log or print the exception and the JSON causing the error
      print('Error parsing JSON: $json');
      print('Exception: $e');
      rethrow; // Re-throw the exception to propagate it further
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'date':date.toIso8601String(),
      'branch_id': branchId,
      'line_no': lineNo,
      'style': style,
      'po_no': poNo,
      'qty': qty,
      'mo': mo,
      'hel': hel,
      'iron': iron,
      'smv': smv,
      'cm': cm,
      'forcast_pcs': forecastPcs,
      'forcast_sah': forecastSah,
      'forcast_eff': forecastEff,
      'actual_pcs': actualPcs,
      'actual_sah': actualSah,
      'actual_eff': actualEff,
      'income': income,
    };
  }


}
