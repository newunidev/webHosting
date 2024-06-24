
class CalculateCM{

  double _cmValue =0.0;

  double getCmValue(int qty, double smv){

    // if(smv <10 && qty >= 1 && qty <= 100){
    //   _cmValue = smv * 0.090;
    //
    // }
    if(smv<10){
      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.090;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.080;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.070;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.060;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.055;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.050;
      }else if(qty>=5001){
        _cmValue = smv * 0.045;
      }
    }else if(smv >=10 && smv<20){

      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.110;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.090;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.070;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.065;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.060;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.055;
      }else if(qty>=5001){
        _cmValue = smv * 0.050;
      }
    }else if(smv >=20 && smv <30){
      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.120;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.100;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.080;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.070;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.060;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.055;
      }else if(qty>=5001){
        _cmValue = smv * 0.050;
      }
    }else if(smv >=30 && smv<60){
      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.150;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.130;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.100;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.085;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.075;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.065;
      }else if(qty>=5001){
        _cmValue = smv * 0.060;
      }
    }else if(smv>=60 && smv<90){
      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.180;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.160;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.130;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.105;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.085;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.075;
      }else if(qty>=5001){
        _cmValue = smv * 0.070;
      }
    }else if(smv>=90){
      if(qty >= 1 && qty <= 100){
        _cmValue = smv * 0.230;
      }else if(qty>101 && qty <=300){
        _cmValue = smv * 0.210;
      }else if(qty >= 301 && qty <= 600){
        _cmValue = smv * 0.180;
      }else if(qty >= 601 && qty <= 1000){
        _cmValue = smv * 0.135;
      }else if(qty >= 1001 && qty <= 2000){
        _cmValue = smv * 0.115;
      }else if(qty >= 2001 && qty <= 5000){
        _cmValue = smv * 0.095;
      }else if(qty>=5001){
        _cmValue = smv * 0.090;
      }
    }

    return _cmValue;
  }

  double getCmValueUsingQtyRange(double smv, String qtyRange){

    if(smv<10){
      if(qtyRange == "1-100"){
        _cmValue = smv * 0.090;
      }else if(qtyRange == "101-300"){
        _cmValue = smv * 0.080;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.070;
      }else if( qtyRange == "601-1000"){
        _cmValue = smv * 0.060;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.055;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.050;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.045;
      }

    }else if(smv >=10 && smv<20){
      if( qtyRange == "1-100"){
        _cmValue = smv * 0.110;
      }else if(qtyRange == "101-300" ){
        _cmValue = smv * 0.090;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.070;
      }else if(qtyRange == "601-1000"){
        _cmValue = smv * 0.065;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.060;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.055;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.050;
      }

    }else if(smv >=20 && smv <30){

      if(qtyRange == "1-100"){
        _cmValue = smv * 0.120;
      }else if(qtyRange == "101-300"){
        _cmValue = smv * 0.100;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.080;
      }else if(qtyRange == "601-1000"){
        _cmValue = smv * 0.070;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.060;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.055;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.050;
      }

    }else if(smv >=30 && smv<60){
      if(qtyRange == "1-100"){
        _cmValue = smv * 0.150;
      }else if(qtyRange == "101-300"){
        _cmValue = smv * 0.130;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.100;
      }else if(qtyRange == "601-1000"){
        _cmValue = smv * 0.085;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.075;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.065;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.060;
      }
    }else if(smv>=60 && smv<90){
      if(qtyRange == "1-100"){
        _cmValue = smv * 0.180;
      }else if(qtyRange == "101-300"){
        _cmValue = smv * 0.160;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.130;
      }else if(qtyRange == "601-1000"){
        _cmValue = smv * 0.105;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.085;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.075;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.070;
      }
    }else if(smv>=90){
      if(qtyRange == "1-100"){
        _cmValue = smv * 0.230;
      }else if(qtyRange == "101-300"){
        _cmValue = smv * 0.210;
      }else if(qtyRange == "301-600"){
        _cmValue = smv * 0.180;
      }else if(qtyRange == "601-1000"){
        _cmValue = smv * 0.135;
      }else if(qtyRange == "1001-2000"){
        _cmValue = smv * 0.115;
      }else if(qtyRange == "2001-5000"){
        _cmValue = smv * 0.095;
      }else if(qtyRange == "5000+"){
        _cmValue = smv * 0.090;
      }
    }

    return _cmValue;

  }



}