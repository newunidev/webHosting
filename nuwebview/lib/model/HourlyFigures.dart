class HourlyFiguresDto {
  late DateTime date;
  late String branchId;
  late int lineNo;
  late String style;
  late int hourQty;
  late String hourslot;


  HourlyFiguresDto.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    branchId = json['branch_id'];
    lineNo = json['line_no'];
    style = json['style'];
    hourQty = json['hourqty'];
    hourslot = json['hourslot'];
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'branch_id': branchId,
      'line_no': lineNo,
      'style': style,
      'hourqty':hourQty,
      'hourslot':hourslot
    };
  }
}