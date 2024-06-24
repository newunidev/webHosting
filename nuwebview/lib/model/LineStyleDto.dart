class LineStyleDto{
  late int _lineNo;
  late String _style;
  late String _poNo;

  LineStyleDto(this._lineNo, this._style,this._poNo);

  String get style => _style;

  set style(String value) {
    _style = value;
  }

  int get lineNo => _lineNo;

  set lineNo(int value) {
    _lineNo = value;
  }

  String get poNo =>_poNo;
  set poNo(String value){
    _poNo=value;
  }

}