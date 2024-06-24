class DailyFigures{
  late DateTime _date;
  late String _branchId;
  late int _lineNo;
  late String _style;
  late String _poNo;
  late String _qtyRange;
  late int _qty;
  late int _mo;
  late int _hel;
  late int _iron;
  late double _smv;
  late int _wMin;
  late int _forecastPcs;

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get branchId => _branchId;

  int get forecastPcs => _forecastPcs;

  set forecastPcs(int value) {
    _forecastPcs = value;
  }

  int get wMin => _wMin;

  set wMin(int value) {
    _wMin = value;
  }

  double get smv => _smv;

  set smv(double value) {
    _smv = value;
  }

  int get iron => _iron;

  set iron(int value) {
    _iron = value;
  }

  int get hel => _hel;

  set hel(int value) {
    _hel = value;
  }

  int get mo => _mo;

  set mo(int value) {
    _mo = value;
  }

  int get qty => _qty;

  set qty(int value) {
    _qty = value;
  }

  String get qtyRange => _qtyRange;

  set qtyRange(String value) {
    _qtyRange = value;
  }

  String get poNo => _poNo;

  set poNo(String value) {
    _poNo = value;
  }

  String get style => _style;

  set style(String value) {
    _style = value;
  }

  int get lineNo => _lineNo;

  set lineNo(int value) {
    _lineNo = value;
  }

  set branchId(String value) {
    _branchId = value;
  }
}