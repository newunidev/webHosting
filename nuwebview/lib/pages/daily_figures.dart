import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


import '../background/background.dart';
import '../const/api.dart';
import '../const/const_data.dart';
import '../const/ui_constant.dart';
import '../controller/calculatecm.dart';
import '../controller/dailydatavalidation.dart';
import '../controller/factory_selector.dart';
import '../model/DailyFiguresDto.dart';
import '../model/efficiencyDtoSend.dart';
import '../widgets/flexible_space_app_bar.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';

class DailyFigures extends StatefulWidget {
  const DailyFigures({super.key});

  @override
  State<DailyFigures> createState() => _DailyFiguresState();
}

class _DailyFiguresState extends State<DailyFigures> {
  FactorySelector factorySelector = FactorySelector();

  //method for show SnackBar'
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }



  DateTime selectedDate = DateTime.now();
  String? _selectedBranch;
  String _styleText = '';
  //String _lineNoText = ''; //have to convert this into into when sending this into db model
  String? _selectedLineNo;//check
  String _poNumberText = '';
  String _qtyText = '';
  String _machineOperatorsCountText = '';
  String _helpersCountText = '';
  String _ironCountText = '';
  String _smvText = '';
  String _forcastPcsText = '';
  String _actualPcsText = '';
  String? _selectedQuantityRange;
  String? _selectedWorkingMin;


  //create object for calculatecmClass instace
  CalculateCM calculateCM = CalculateCM();

  // Validate method for each field - from the validation class
  DailyDataValidation dailyDataValidation = new DailyDataValidation();

  //Create a Efficinecy Model
  //EfficiencyDtoSend efficiencyDtoSend = EfficiencyDtoSend();





  //method for clear all fields
  void clearFormFields() {
    setState(() {
      _selectedBranch = null;
      //_styleController.clear();
      _selectedLineNo = null;
      _poNumberText = '';
      _qtyText = "";
      _machineOperatorsCountText = '';
      _helpersCountText = '';
      _ironCountText = '';
      _smvText = '';
      _forcastPcsText = " ";
      _actualPcsText = '';
      _selectedQuantityRange = null;
      _selectedWorkingMin = null;

      // Add more variables if needed for other fields
    });
  }


  //void add dataTO the DB
  Future<void> addData(
     DateTime date,
     String branchId,
     int lineNo,
     String style,
     String poNo,
     String qtyRange,
     int qty,
     int mo,
     int hel,
     int iron,
     double smv,
     int wMin,
     int forecastPcs,
  ) async {
    // Constructing the DailyFiguresDto
    DailyFiguresDto dailyFiguresDto = DailyFiguresDto.fromJson({
      'date': date.toIso8601String(),
      'branch_id': branchId,
      'line_no': lineNo,
      'style': style,
      'po_no': poNo,
      'qty_range': qtyRange,
      'qty': qty,
      'mo': mo ,
      'hel': hel ,
      'iron': iron ,
      'smv': smv ,
      'wMin': wMin ,
      'forcast_pcs': forecastPcs ,
    });

    try {
          // Convert efficiencyDto to a Map
      Map<String, dynamic> jsonData = dailyFiguresDto.toJson();

          // Send a POST request to your Node.js server to insert data into the database
      final response = await http.post(
        Uri.parse('${API.apiUrl}dailyfigures'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 201) {
        //print('Data inserted successfully');
        print('Data added successfully. Inserted row ID: $response');
        _showSnackBar('Data added successfully');
        navigateToDailyDataForm();
        clearFormFields();

      }else if(response.statusCode == 500){
        print('Failed to insert data. Line Duplicated ${response.body}');
        _showSnackBar('Fail to insert data with Duplicate Line');
      } else {
        print('Failed to insert data. Status code: ${response.statusCode}');
        _showSnackBar('Fail to insert data with status code ${response.statusCode}');
            // Handle error accordingly
      }
    } catch (e) {
      print('Error during data insertion: $e');
      // Handle error accordingly
    }


  }

  // Future<void> addData(
  //     DateTime date,
  //     String selectedBranch,
  //     String style,
  //     int selectedLine,
  //     String poNo,
  //     String qtyRange,
  //     int qty,
  //     int mo,
  //     int hel,
  //     int iron,
  //     double smv,
  //     int wMin,
  //     int forecastPcs,
  //     ) async {
  //   EfficiencyDtoSend efficiencyDto = EfficiencyDtoSend.fromJson({
  //     'date': date,
  //     'branch_id': selectedBranch,
  //     'line_no': selectedLine,
  //     'style': style,
  //     'po_no': poNo,
  //     'qty': qty,
  //     'mo': mo,
  //     'hel': hel,
  //     'iron': iron,
  //    // 'smv': smv,
  //    // 'cm': cm,
  //     'forcast_pcs': forecastPcs,
  //    // 'forcast_sah': forecastSah,
  //    // 'forcast_eff': forecastEff,
  //    /// 'actual_pcs': actualPcs,
  //     //'actual_sah': actualSah,
  //    // 'actual_eff': actualEff,
  //    // 'income': income,
  //   });
  //
  //   try {
  //     // Convert efficiencyDto to a Map
  //     Map<String, dynamic> jsonData = efficiencyDto.toJson();
  //
  //     // Send a POST request to your Node.js server to insert data into the database
  //     final response = await http.post(
  //       Uri.parse('${API.apiUrl}efficiency'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(jsonData),
  //     );
  //
  //     if (response.statusCode == 201) {
  //       //print('Data inserted successfully');
  //       print('Data added successfully. Inserted row ID: $response');
  //       _showSnackBar('Data added successfully');
  //       navigateToDailyDataForm();
  //       clearFormFields();
  //
  //
  //     }else if(response.statusCode == 500){
  //       print('Failed to insert data. Style Duplicated');
  //       _showSnackBar('Fail to insert data with Duplicated Style');
  //     } else {
  //       print('Failed to insert data. Status code: ${response.statusCode}');
  //       _showSnackBar('Fail to insert data with status code ${response.statusCode}');
  //       // Handle error accordingly
  //     }
  //   } catch (e) {
  //     print('Error during data insertion: $e');
  //     // Handle error accordingly
  //   }
  // }



  //check data wise pikcing is okay


  // void displayDataByDate() async{
  //   DatabaseHelper dbHelper = DatabaseHelper();
  //
  //   // Get efficiency data from the database
  //   List<Map<String, dynamic>> efficiencyDataByDate = await dbHelper.getEfficiencyDataForDate();
  //
  //   // Print the retrieved data
  //   for (Map<String, dynamic> data in efficiencyDataByDate) {
  //     data.forEach((key, value) {
  //       print('$key: $value');
  //     });
  //     print('---'); // Add a separator line after each map
  //   }
  // }


  // Function to show DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:  currentDate,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _handleDateSelected(selectedDate);
      });
    }

  }

  void navigateToDailyDataForm() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DailyFigures()),
    );
  }

  // List of branches for ComboBox
  List<String> _branches = ['Bakamuna Factory', 'Hettipola Factory', 'Mathara Factory','Piliyandala Factory','Welioya Factory'];

  //final List<String> _branchesTest = ['Bakamuna Factory', 'Hettipola Factory', 'Mathara Factory','Piliyandala Factory','Welioya Factory'];

  final Map<String, List<String>> _lineNumbersByBranch = {
    'Bakamuna Factory': ['01', '02', '03', '04'],
    'Hettipola Factory': ['01', '02', '03', '04', '05', '06'],
    'Mathara Factory': ['01', '02', '03', '04'],
    'Piliyandala Factory': ['01',],
    'Welioya Factory': ['01', '02'],
  };

  final List<String> quantityRanges = ['1-100', '101-300', '301-600', '601-1000', '1001-2000','2001-5000','5000+' ];
  //_branches =ConstData.setFactoryOnUser();

  // =====Working min Saturday and other calculation methods=========//

  // Function to determine if the selected date is a Saturday
  bool isSaturday(DateTime date) {

    return date.weekday == DateTime.saturday;
  }

// Function to handle date selection
  void _handleDateSelected(DateTime selectedDate) {

    setState(() {
      selectedDate = selectedDate;
      // Automatically set the working minutes based on the selected date
      bool check = isSaturday(selectedDate);
      print("Check Is staturday :${check} }");
      _selectedWorkingMin = isSaturday(selectedDate) ? '480' : '540';

    });

  }





  @override
  Widget build(BuildContext context) {
    double width = ConstData.deviceScreenWidth;
    _branches =factorySelector.setFactoryOnUser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        flexibleSpace: FlexibleSpaceAppBar(),
        title: Text(
          "New Universe",
          style: TextStyle(
            color: AppColors.yellowGold, // Dark yellow color
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: BackgroundImage(
          child: Center(
            child: Padding(

              padding: const EdgeInsets.all(20),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date Picker and Branch ComboBox Section
                    Container(
                      width: ConstData.deviceScreenWidth/1,
                      decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(width: 10.0),
                          DropdownButton<String>(
                            value: _selectedBranch,
                            hint: const Text('Select Branch'),
                            items: _branches.map((branch) {
                              return DropdownMenuItem<String>(
                                value: branch,
                                child: Text(branch),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranch = value;
                                // Reset selected line number when branch changes
                                _selectedLineNo = null;
                              });
                            },
                          ),
                          SizedBox(width: 20.0),
                          Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                          IconButton(
                            onPressed: () {
                              _selectDate(context);

                            },
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Style and LineNo TextFields Section
                    Container(
                      width: ConstData.deviceScreenWidth/1,
                      decoration: BoxDecoration(


                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('Line No:'),


                          DropdownButton<String>(
                            value: _selectedLineNo,
                            hint: const Text('Select Line No',style: TextStyle(color: Colors.grey),),

                            items: _lineNumbersByBranch[_selectedBranch ?? '']?.map((lineNo) {
                              return DropdownMenuItem<String>(
                                value: lineNo,
                                child: Text(lineNo),
                              );
                            }).toList() ??
                                <DropdownMenuItem<String>>[
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('No line numbers Available'),
                                  ),
                                ],
                            onChanged: (value) {
                              setState(() {
                                _selectedLineNo = value!;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          // Style TextField
                          Text('Style:'),
                          TextField(
                            //controller: _styleController,
                            onChanged: (value) {
                              setState(() {
                                _styleText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter style here',
                              hintStyle: TextStyle(color: Colors.grey),

                            ),
                          ),
                          SizedBox(height: 16.0),

                          // LineNo dropfown

                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),
                    Container(
                      width: ConstData.deviceScreenWidth/1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Style TextField
                          Text('PO Number:'),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                _poNumberText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter PO Number',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // Quantity Range Dropdown
                          Text('Quantity Range:'),
                          DropdownButtonFormField<String>(
                            value: _selectedQuantityRange,
                            hint: const Text('Select Quantity Range'),
                            items: [
                              '1-100',
                              '101-300',
                              '301-600',
                              '601-1000',
                              '1001-2000',
                              '2001-5000',
                              '5000+',
                            ].map((range) {
                              return DropdownMenuItem<String>(
                                value: range,
                                child: Text(range),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedQuantityRange = value;
                                print(_selectedQuantityRange);
                              });
                            },
                          ),
                          SizedBox(height: 16.0),

                          // LineNo TextField
                          Text('Quantity:'),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _qtyText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Order Quantity here',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // LineNo TextField
                          Text('Machine Operators:'),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _machineOperatorsCountText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Machine Operators Count',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // LineNo TextField
                          Text('Helpers:'),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _helpersCountText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Helpers Count',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // LineNo TextField
                          Text('Iron:'),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _ironCountText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Iron Count',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.00,),
                    Container(
                      width: ConstData.deviceScreenWidth/1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Style TextField
                          Text('SMV:'),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),  // Set keyboardType to allow numbers and decimals
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),  // Allow only numbers and up to two decimal places
                            ],
                            onChanged: (value) {
                              setState(() {
                                _smvText = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter SMV here',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          Text('Working Min:'),
                          //SizedBox(width: 8.0), // Add some spacing between text and dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedWorkingMin,
                            hint: const Text('Select Working Min'),
                            items: [
                              '480',
                              '540'
                            ].map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            // Disable the dropdown to prevent manual selection
                            onChanged: null,
                          ),
                        ],
                      ),
                    ),



                    SizedBox(height: 16.0),

                    Container(
                      width: ConstData.deviceScreenWidth/1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add some vertical space between rows

                          // New Row for Forecast PCS and Forecast SAH
                          Row(
                            children: [
                              // Forecast PCS TextField
                              Text('Forecast PCS:'),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  onChanged: (value) {
                                    _forcastPcsText = value;
                                  },
                                  decoration: InputDecoration(
                                    // hintText: 'Enter Forecast PCS',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.0), // Add some space between Forecast PCS and Forecast SAH

                              // Forecast SAH TextField

                            ],
                          ),
                          SizedBox(height: 16.0), // Add some vertical space between rows

                          // Additional TextField below the above textboxes
                          TextField(
                            onChanged: (value) {
                              // Handle onChanged for the additional TextField
                              // You can save the value to a variable if needed
                            },
                            decoration: InputDecoration(
                              hintText: 'Additional Data',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.0),
                    // Submit Button Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(

                            onPressed: () {
                              // Validate the fields
                              String? branchError = dailyDataValidation.validateBranch(_selectedBranch);
                              String? styleError = dailyDataValidation.validateStyle(_styleText);
                              String? lineNoError = dailyDataValidation.validateLineNo(_selectedLineNo);
                              String? poNoError = dailyDataValidation.validatePoNo(_poNumberText);
                              String? qtyError = dailyDataValidation.validateQty(_qtyText);
                              String? qtyRangeError = dailyDataValidation.validateQtyRange(_selectedQuantityRange);
                              String? machineOppError = dailyDataValidation.validatePoNo(_machineOperatorsCountText);
                              String? helperError = dailyDataValidation.validatePoNo(_helpersCountText);
                              String? ironError = dailyDataValidation.validatePoNo(_ironCountText);
                              String? smvError = dailyDataValidation.validateSMV(_smvText);
                              String? forecastPcsError = dailyDataValidation.validateForcastPcs(_forcastPcsText);
                              //String? actualPcsError = dailyDataValidation.validateActualPcs(_actualPcsText);
                              String? workingMinError = dailyDataValidation.validateActualPcs(_selectedWorkingMin);

                              if (branchError == null && styleError == null && lineNoError == null && poNoError == null && qtyError == null && machineOppError == null && helperError == null && ironError == null && smvError == null  && forecastPcsError == null && qtyRangeError == null && workingMinError == null) {
                                    print('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
                                    print('Branch: $_selectedBranch');
                                    print('Style: $_styleText');
                                    print('Line No: $_selectedLineNo');
                                    print('PO: $_poNumberText');
                                    print('Quantity: $_qtyText');
                                    print('MO: $_machineOperatorsCountText');
                                    print('HELP: $_helpersCountText');
                                    print('Iron: $_ironCountText');
                                    print('SMV: $_smvText');
                                    print('Working Min: $_selectedWorkingMin');
                                    print('Forecast PCS: $_forcastPcsText');



                                    // int intValue = int.parse(_lineNoText);
                                    // print(intValue);
                                    //converted Values
                                    int qtyInt =int.parse(_qtyText);
                                    int moInt = int.parse(_machineOperatorsCountText.toString());
                                    int helpInt = int.parse(_helpersCountText.toString());
                                    int ironInt = int.parse(_ironCountText.toString());
                                    int forcastPcsInt = int.parse(_forcastPcsText);
                                    int workingMin = int.parse(_selectedWorkingMin.toString());
                                    double smvDouble = double.parse(_smvText.toString());

                                    addData(
                                        selectedDate,
                                        _selectedBranch.toString(),
                                        int.parse(_selectedLineNo.toString()),
                                        _styleText, _poNumberText,
                                        _selectedQuantityRange.toString(),
                                        qtyInt,
                                        moInt,
                                        helpInt,
                                        ironInt,
                                        smvDouble,
                                        workingMin,
                                        forcastPcsInt
                                    );






                              } else {
                                    // Show error messages
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                        content: Text('Please fill in all required fields.'),
                                      ),
                                  );
                              }




                            //
                            //   //print(poNoError);
                            //
                            //   // Check if any validation errors exist
                            //   if (branchError == null && styleError == null && lineNoError == null && poNoError == null && qtyError == null && machineOppError == null && helperError == null && ironError == null && smvError == null && actualPcsError == null && forecastPcsError == null && qtyRangeError == null && workingMinError == null) {
                            //     // Form is valid, add your logic to save data to the database
                            //     print('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}');
                            //     print('Branch: $_selectedBranch');
                            //     print('Style: $_styleText');
                            //     print('Line No: $_selectedLineNo');
                            //     print('PO: $_poNumberText');
                            //     print('Quantity: $_qtyText');
                            //     print('MO: $_machineOperatorsCountText');
                            //     print('HELP: $_helpersCountText');
                            //     print('Iron: $_ironCountText');
                            //     print('SMV: $_smvText');
                            //     print('Working Min: $_selectedWorkingMin');
                            //     print('Forecast PCS: $_forcastPcsText');
                            //     print('Actual PCS: $_actualPcsText');
                            //     // int intValue = int.parse(_lineNoText);
                            //     // print(intValue);
                            //
                            //
                            //     //=================================Calculatoins==============================//
                            //     //calculate the cmValue
                            //
                            //     int qtyInt =int.parse(_qtyText);
                            //     double smvDouble = double.parse(_smvText);
                            //     int totalAllocations = int.parse(_machineOperatorsCountText)+int.parse(_helpersCountText)+int.parse(_ironCountText);
                            //     int workingMin = int.parse(_selectedWorkingMin.toString());
                            //     double income =0.0;
                            //
                            //     //_cmValue = calculateCM.getCmValue(qtyInt, smvDouble);
                            //     _cmValue = calculateCM.getCmValueUsingQtyRange(smvDouble,_selectedQuantityRange.toString());
                            //     print('CM: $_cmValue');
                            //
                            //     //==Forcast==//
                            //     // calculate the forcast SAH
                            //     int forcastPcsInt = int.parse(_forcastPcsText);
                            //     _forecastSahValue = (forcastPcsInt * smvDouble)/60;
                            //     print('Forecast SAH : $_forecastSahValue');
                            //
                            //     // calculate the forcast efficiency
                            //
                            //     _forecastEfficiency = (forcastPcsInt *smvDouble)/totalAllocations/workingMin;
                            //     double roundedForecastEfficiency = double.parse(_forecastEfficiency.toStringAsFixed(2));
                            //     print("Working minute is :${workingMin}");
                            //     print("Forcast Efficiency : ${roundedForecastEfficiency}");
                            //
                            //
                            //     // ==== Actual === //
                            //     // calculate the actual SAH
                            //     int actualPcsInt = int.parse(_actualPcsText);
                            //     _actualSahValue = (actualPcsInt * smvDouble)/60;
                            //
                            //
                            //     // calculate the forcast efficiency
                            //
                            //     _actualEfficiency = (actualPcsInt *smvDouble)/totalAllocations/workingMin;
                            //     double roundedActualEfficiency = double.parse(_actualEfficiency.toStringAsFixed(2));
                            //     print("Actual Efficiency : ${roundedActualEfficiency}");
                            //
                            //
                            //     //calculate the income
                            //     _income = actualPcsInt *_cmValue;
                            //
                            //
                            //     int moInt = int.parse(_machineOperatorsCountText.toString());
                            //     int helpInt = int.parse(_helpersCountText.toString());
                            //     int ironInt = int.parse(_ironCountText.toString());
                            //
                            //
                            //
                            //     //calling the method addDataTo the database
                            //     addData(selectedDate,
                            //       _selectedBranch.toString(),
                            //       _styleText,
                            //       int.parse(_selectedLineNo.toString()),
                            //       _poNumberText, qtyInt,
                            //       moInt,
                            //       helpInt,
                            //       ironInt,
                            //       smvDouble,
                            //       double.parse(_cmValue.toStringAsFixed(2)),
                            //       forcastPcsInt,
                            //       double.parse(_forecastSahValue.toStringAsFixed(2)),
                            //       double.parse(_forecastEfficiency.toStringAsFixed(2)),
                            //       actualPcsInt,
                            //       double.parse(_actualSahValue.toStringAsFixed(2)),
                            //       double.parse(_actualEfficiency.toStringAsFixed(2)),
                            //       double.parse(_income.toStringAsFixed(2)),
                            //     );
                            //
                            //
                            //   } else {
                            //     // Show error messages
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text('Please fill in all required fields.'),
                            //       ),
                            //     );
                            //   }
                            },

                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent), // Change to your desired color
                            ),

                            child: Text('Submit',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0,
                            ),),
                          ),
                          ElevatedButton(

                            onPressed: () {

                              //displayData();
                              clearFormFields();
                              //_forcastPcsText ="AA";
                              //displayDataByDate();

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.red), // Change to your desired color
                            ),

                            child: Text('Clear',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        backgroundColor: AppColors.blueDark,
        color: Colors.white38,

        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          if(index == 0){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  Dashboard(),
              ),
            );
          }
        },
      ),
    );
  }
}
