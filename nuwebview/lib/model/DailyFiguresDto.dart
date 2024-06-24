class DailyFiguresDto {
  late DateTime date;
  late String branchId;
  late int lineNo;
  late String style;
  late String poNo;
  late String qtyRange;
  late int qty;
  late int mo;
  late int hel;
  late int iron;
  late double smv;
  late int wMin;
  late int forecastPcs;

  DailyFiguresDto.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    branchId = json['branch_id'];
    lineNo = json['line_no'];
    style = json['style'];
    poNo = json['po_no'];
    qtyRange = json['qty_range'];
    qty = json['qty'];
    mo = json['mo'];
    hel = json['hel'];
    iron = json['iron'];
    smv = json['smv'].toDouble();
    wMin = json['wMin'];
    forecastPcs = json['forcast_pcs'];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'branch_id': branchId,
      'line_no': lineNo,
      'style': style,
      'po_no': poNo,
      'qty_range': qtyRange,
      'qty': qty,
      'mo': mo,
      'hel': hel,
      'iron': iron,
      'smv': smv,
      'wMin': wMin,
      'forcast_pcs': forecastPcs,
    };
  }
}
