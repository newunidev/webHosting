
class DailyDataValidation{


  String? validateBranch(String? value) {
    if (value == null || value.isEmpty) {
      return 'Branch is required';
    }
    return null;
  }

  String? validateStyle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Style is required';
    }
    return null;
  }

  String? validateLineNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Line No is required';
    }
    return null;
  }

  String? validatePoNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'PO No is required';
    }
    return null;
  }
  String? validateQty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }
    return null;
  }
  String? validateQtyRange(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity Range is required';
    }
    return null;
  }

  String? validateMachineOperators(String? value) {
    if (value == null || value.isEmpty) {
      return 'Machine Opp is required';
    }
    return null;
  }

  String? validateHelper(String? value) {
    if (value == null || value.isEmpty) {
      return 'Helper is required';
    }
    return null;
  }
  String? validateIron(String? value) {
    if (value == null || value.isEmpty) {
      return 'Iron is required';
    }
    return null;
  }
  String? validateSMV(String? value) {
    if (value == null || value.isEmpty) {
      return 'SMV is required';
    }
    return null;
  }
  String? validateWorkingMin(String? value) {
    if (value == null || value.isEmpty) {
      return 'WorkingMin is required';
    }
    return null;
  }
  String? validateForcastPcs(String? value) {
    if (value == null || value.isEmpty) {
      return 'Forcast Pcs are required';
    }
    return null;
  }
  String? validateActualPcs(String? value) {
    if (value == null || value.isEmpty) {
      return 'Actual pcs are required';
    }
    return null;
  }
}