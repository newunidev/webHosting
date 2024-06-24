class EfficiencyInterTransferDto {
  late DateTime _date;
  late String _branchId;
  late int _lineNo;
  late String _style;
  late String _poNo;
  late int _qty;
  late int _mo;
  late int _hel;
  late int _iron;
  late double _smv;
  late double _cm;
  late int _forecastPcs;
  late double _forecastSah;
  late double _forecastEff;
  late int _actualPcs;
  late double _actualSah;
  late double _actualEff;
  late double _income;

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get branchId => _branchId;

  double get income => _income;

  set income(double value) {
    _income = value;
  }

  double get actualEff => _actualEff;

  set actualEff(double value) {
    _actualEff = value;
  }

  double get actualSah => _actualSah;

  set actualSah(double value) {
    _actualSah = value;
  }

  int get actualPcs => _actualPcs;

  set actualPcs(int value) {
    _actualPcs = value;
  }

  double get forecastEff => _forecastEff;

  set forecastEff(double value) {
    _forecastEff = value;
  }

  double get forecastSah => _forecastSah;

  set forecastSah(double value) {
    _forecastSah = value;
  }

  int get forecastPcs => _forecastPcs;

  set forecastPcs(int value) {
    _forecastPcs = value;
  }

  double get cm => _cm;

  set cm(double value) {
    _cm = value;
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