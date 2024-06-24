
import '../model/DailyFigures.dart';
import '../model/EfficiencyInterTransfterDto.dart';
import 'calculatecm.dart';

class CalculateEfficiencyTableData{

  CalculateCM calculateCM = new CalculateCM();

  EfficiencyInterTransferDto efficiencyInterTransferDto = new EfficiencyInterTransferDto();

  EfficiencyInterTransferDto calculateEfficiencyData(DailyFigures dailyFigures,int totalActualPcs){
    //I have to calculate the cm,fSAH,fEFF,aSAH,aEFF,income
    double smvDouble = dailyFigures.smv;
    int forecastPcs = dailyFigures.forecastPcs;
    int totalAllocations = dailyFigures.mo+dailyFigures.hel+dailyFigures.iron;
    int workinMin = dailyFigures.wMin;


    //CM Calculation
    double _cmValue = calculateCM.getCmValueUsingQtyRange(dailyFigures.smv,dailyFigures.qtyRange);
    print('CM: $_cmValue');


    //Calculate forecast Sah Value
    double _forecastSah = (forecastPcs * smvDouble)/60;
    print('Forecast SAH : $_forecastSah');

    // calculate the forcast efficiency

    double _forecastEfficiency = (forecastPcs *smvDouble)/totalAllocations/workinMin;
    double roundedForecastEfficiency = double.parse(_forecastEfficiency.toStringAsFixed(2));
    print("Working minute is :${workinMin}");
    print("Forcast Efficiency : ${roundedForecastEfficiency}");


    // ==== Actual === //
    // calculate the actual SAH
    int actualPcsInt = totalActualPcs;
    double _actualSahValue = (actualPcsInt * smvDouble)/60;


    // calculate the forcast efficiency

    double _actualEfficiency = (actualPcsInt *smvDouble)/totalAllocations/workinMin;
    double roundedActualEfficiency = double.parse(_actualEfficiency.toStringAsFixed(2));
    print("Actual Efficiency : ${roundedActualEfficiency}");


    //calculate the income
    double _income = actualPcsInt *_cmValue;

    //set data to the efficienyInterTransferDto
    efficiencyInterTransferDto.date = dailyFigures.date;
    efficiencyInterTransferDto.branchId = dailyFigures.branchId;
    efficiencyInterTransferDto.lineNo = dailyFigures.lineNo;
    efficiencyInterTransferDto.style = dailyFigures.style;
    efficiencyInterTransferDto.poNo = dailyFigures.poNo;
    efficiencyInterTransferDto.date = dailyFigures.date;
    efficiencyInterTransferDto.qty = dailyFigures.qty;
    efficiencyInterTransferDto.mo = dailyFigures.mo;
    efficiencyInterTransferDto.hel = dailyFigures.hel;
    efficiencyInterTransferDto.iron = dailyFigures.iron;
    efficiencyInterTransferDto.smv = dailyFigures.smv;
    efficiencyInterTransferDto.cm = _cmValue;
    efficiencyInterTransferDto.forecastPcs = dailyFigures.forecastPcs;
    efficiencyInterTransferDto.forecastSah = _forecastSah;
    efficiencyInterTransferDto.forecastEff = _forecastEfficiency;
    efficiencyInterTransferDto.actualPcs = totalActualPcs;
    efficiencyInterTransferDto.actualSah = _actualSahValue;
    efficiencyInterTransferDto.actualEff = _actualEfficiency;
    efficiencyInterTransferDto.income = _income;


    print("Efficiency Data : ${efficiencyInterTransferDto.income}");

    return efficiencyInterTransferDto;









  }


}