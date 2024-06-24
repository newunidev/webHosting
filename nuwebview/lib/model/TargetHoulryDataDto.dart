class TargetHourlyDto {
  late int _lineNo;
  late int _mo;
  late int _help; // Assuming 'Help' is a numerical value
  late int _iron;
  late String _style;
  late double _smv;
  late int _hour1;
  late int _hour2;
  late int _hour3;
  late int _hour4;
  late int _hour5;
  late int _hour6;
  late int _hour7;
  late int _hour8;
  late int _hour9;
  late int _hour10;
  late int _forecastPcs;
  late int _total;
  late int _difference;


  int get forecastPcs => _forecastPcs;

  set forecastPcs(int value) {
    _forecastPcs = value;
  } // TargetHourlyDto(
  //     this._lineNo,
  //     this._mo,
  //     this._help,
  //     this._iron,
  //     this._style,
  //     this._smv,
  //     this._hour1,
  //     this._hour2,
  //     this._hour3,
  //     this._hour4,
  //     this._hour5,
  //     this._hour6,
  //     this._hour7,
  //     this._hour8,
  //     this._hour9,
  //     this._hour10,
  //     this._total,
  //     this._difference);


  int get difference => _difference;

  set difference(int value) {
    _difference = value;
  }

  int get total => _total;

  set total(int value) {
    _total = value;
  }

  int get hour10 => _hour10;

  set hour10(int value) {
    _hour10 = value;
  }

  int get hour9 => _hour9;

  set hour9(int value) {
    _hour9 = value;
  }

  int get hour8 => _hour8;

  set hour8(int value) {
    _hour8 = value;
  }

  int get hour7 => _hour7;

  set hour7(int value) {
    _hour7 = value;
  }

  int get hour6 => _hour6;

  set hour6(int value) {
    _hour6 = value;
  }

  int get hour5 => _hour5;

  set hour5(int value) {
    _hour5 = value;
  }

  int get hour4 => _hour4;

  set hour4(int value) {
    _hour4 = value;
  }

  int get hour3 => _hour3;

  set hour3(int value) {
    _hour3 = value;
  }

  int get hour2 => _hour2;

  set hour2(int value) {
    _hour2 = value;
  }

  int get hour1 => _hour1;

  set hour1(int value) {
    _hour1 = value;
  }

  double get smv => _smv;

  set smv(double value) {
    _smv = value;
  }

  String get style => _style;

  set style(String value) {
    _style = value;
  }

  int get iron => _iron;

  set iron(int value) {
    _iron = value;
  }

  int get help => _help;

  set help(int value) {
    _help = value;
  }

  int get mo => _mo;

  set mo(int value) {
    _mo = value;
  }

  int get lineNo => _lineNo;

  set lineNo(int value) {
    _lineNo = value;
  }

  @override
  String toString() {
    return 'TargetHourlyDto(lineNo: $lineNo, style: $style, mo: $mo, hel: $help, iron: $iron, smv: $smv, hour1: $hour1, hour2: $hour2, hour3: $hour3, hour4: $hour4, hour5: $hour5, hour6: $hour6, hour7: $hour7, hour8: $hour8, hour9: $hour9, hour10: $hour10, total: $total, difference: $difference)';
  }
}
