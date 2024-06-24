import 'dart:async';
import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


import '../const/api.dart';
import '../const/const_data.dart';
import '../const/login_user_routes.dart';
import '../const/ui_constant.dart';
import '../controller/calculation_efficiency_table.dart';
import '../controller/factory_selector.dart';
import '../model/DailyFigures.dart';
import '../model/DailyFiguresDto.dart';
import '../model/EfficiencyInterTransfterDto.dart';
import '../model/HourlyFigures.dart';
import '../model/efficiencyDtoSend.dart';
import 'dashboard.dart';
import 'login.dart';

import 'package:http/http.dart' as http;

class HourlyDataNew extends StatefulWidget {
  const HourlyDataNew({super.key});

  @override
  State<HourlyDataNew> createState() => _HourlyDataNewState();
}

class _HourlyDataNewState extends State<HourlyDataNew> {

  late Timer _timer;
  late DateTime _currentTime = DateTime.now(); // Initialize _currentTime

  @override
  void initState() {
    super.initState();
    disablefieldsAndButtons();
    // Start a timer to update the current time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();

      });
    });
  }

  @override
  void dispose() {
    // Dispose of the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  //=============================/
  var height,width;
  FocusNode textFocusNode = FocusNode();
  int actualTotalPcs =0;

  bool isButtonEnabled1 = true;
  bool isButtonEnabled2 = true;
  bool isButtonEnabled3 = true;
  bool isButtonEnabled4 = true;
  bool isButtonEnabled5 = true;
  bool isButtonEnabled6 = true;
  bool isButtonEnabled7 = true;
  bool isButtonEnabled8 = true;
  bool isButtonEnabled9 = true;
  bool isButtonEnabled10 = true;




  bool isFieldEnabled1 = true;
  bool isFieldEnabled2 = true;
  bool isFieldEnabled3 = true;
  bool isFieldEnabled4 = true;
  bool isFieldEnabled5 = true;
  bool isFieldEnabled6 = true;
  bool isFieldEnabled7 = true;
  bool isFieldEnabled8 = true;
  bool isFieldEnabled9 = true;
  bool isFieldEnabled10 = true;

  Color tickColor1 = Colors.green;
  Color tickColor2 = Colors.green;
  Color tickColor3 = Colors.green;
  Color tickColor4 = Colors.green;
  Color tickColor5 = Colors.green;
  Color tickColor6 = Colors.green;
  Color tickColor7 = Colors.green;
  Color tickColor8 = Colors.green;
  Color tickColor9 = Colors.green;
  Color tickColor10 = Colors.green;

  List<DailyFiguresDto>? dailyFiguresDto = [];
  DailyFigures dailyFigures = new DailyFigures();
  CalculateEfficiencyTableData calculateEfficiencyTableData = new CalculateEfficiencyTableData();
  List<HourlyFiguresDto>? hourlyFiguresDto = [];
  List<String> styleList = [];
  List<String> completedStyleList = [];
  List<String> styleListToStoreFirst =[];

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  FactorySelector factorySelector = FactorySelector();
  String? _selectedLineNo;
  String? _selectedStyle;




  //text field values.
  DateTime selectedDate = DateTime.now();
  String? _selectedBranch;
  String _styleText = '';
  //String _lineNoText = ''; //have to convert this into into when sending this into db model

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

  //controllers
  TextEditingController styleTextController = TextEditingController();
  TextEditingController quantityTextController = TextEditingController();
  TextEditingController smvTextController = TextEditingController();
  TextEditingController forecastPcsTextController = TextEditingController();
  TextEditingController moTextController = TextEditingController();
  TextEditingController helpTextController = TextEditingController();
  TextEditingController ironTextController = TextEditingController();

  //time slot text controllers
  TextEditingController time01Controller = TextEditingController();
  TextEditingController time02Controller = TextEditingController();
  TextEditingController time03Controller = TextEditingController();
  TextEditingController time04Controller = TextEditingController();
  TextEditingController time05Controller = TextEditingController();
  TextEditingController time06Controller = TextEditingController();
  TextEditingController time07Controller = TextEditingController();
  TextEditingController time08Controller = TextEditingController();
  TextEditingController time09Controller = TextEditingController();
  TextEditingController time10Controller = TextEditingController();

  TextEditingController totalPcsController = TextEditingController();



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  final Map<String, List<String>> _lineNumbersByBranch = {
    'Bakamuna Factory': ['01', '02', '03', '04'],
    'Hettipola Factory': ['01', '02', '03', '04', '05', '06'],
    'Mathara Factory': ['01', '02', '03', '04'],
    'Piliyandala Factory': ['01',],
    'Welioya Factory': ['01', '02'],
  };


  //method for load completed styles from the efficiencyTable
  Future<void> loadCompletedStylesFromEfficiencyTable() async{

    try {
      final response = await http.get(Uri.parse('${API.apiUrl}api/stylescompletedbylinedatefactory?lineNo=$_selectedLineNo&date=$formattedDate&factory=${UserDetailRouting.factory}'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        final List<dynamic> decodedData = json.decode(response.body);

        if (decodedData.isNotEmpty) {

          completedStyleList = decodedData.map((item) => item['style'] as String).toList();
          print("Completed Styles${completedStyleList}");

        } else {
          //clearFields();

        }
      } else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data : $e');
    }

    //setState(() {}); // Trigger a rebuild to update the UI
  }




  //method to load styles to the given Line and date
  // Future<void> loadStyles() async{
  //   clearFields();
  //   actualTotalPcs=0;
  //   try {
  //     final response = await http.get(Uri.parse('${API.apiUrl}api/dailyfiguresbylinedatefactory?lineNo=$_selectedLineNo&date=$formattedDate&factory=${UserDetailRouting.factory}'));
  //
  //     if (response.statusCode == 200) {
  //       // If the server returns a 200 OK response, parse the data
  //       final List<dynamic> decodedData = json.decode(response.body);
  //
  //       if (decodedData.isNotEmpty) {
  //         await loadCompletedStylesFromEfficiencyTable();
  //
  //         dailyFiguresDto = decodedData.map((item) => DailyFiguresDto.fromJson(item)).toList();
  //
  //         //String style=dailyFiguresDto![0].style;
  //         //styleTextController.text = '${dailyFiguresDto![0].style}';
  //
  //         //====testing Start
  //         // for(int i=0;i<dailyFiguresDto!.length;i++){
  //         //
  //         //   //styleList!.add(dailyFiguresDto![i].style);
  //         //   styleListToStoreFirst!.add(dailyFiguresDto![i].style);
  //         //
  //         //
  //         //   print(styleListToStoreFirst![i].toString());
  //         //
  //         // }
  //         // for(int i=0;i<styleListToStoreFirst!.length;i++){
  //         //   if(!completedStyleList.contains(styleListToStoreFirst)){
  //         //     styleList!=add(styleListToStoreFirst(i));
  //         //   }
  //         // }
  //         //testing end=====
  //         for(int i=0;i<dailyFiguresDto!.length;i++){
  //
  //           styleList!.add(dailyFiguresDto![i].style);
  //
  //
  //           print(styleList![i].toString());
  //
  //         }
  //         _selectedStyle = styleList[0];
  //
  //       } else {
  //         clearFields();
  //
  //       }
  //     } else if (response.statusCode == 400) {
  //       // If the server returns a 400 Bad Request response, handle the error
  //       throw Exception('Bad Request: ${json.decode(response.body)['error']}');
  //     } else if (response.statusCode == 500) {
  //       // If the server returns a 500 Internal Server Error response, handle the error
  //       throw Exception('Internal Server Error');
  //     } else {
  //       // Handle other status codes if needed
  //       throw Exception('Failed to load data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during data loading: $e');
  //     // Handle other exceptions if needed
  //     throw Exception('Failed to load data : $e');
  //   }
  //
  //   setState(() {}); // Trigger a rebuild to update the UI
  // }
  //updated method for loadStyles with no matching with already completed efficiency
  Future<void> loadStyles() async {
    clearFields();
    actualTotalPcs = 0;

    try {
      final response = await http.get(Uri.parse('${API.apiUrl}api/dailyfiguresbylinedatefactory?lineNo=$_selectedLineNo&date=$formattedDate&factory=${UserDetailRouting.factory}'));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the data
        final List<dynamic> decodedData = json.decode(response.body);

        if (decodedData.isNotEmpty) {
          await loadCompletedStylesFromEfficiencyTable();

          dailyFiguresDto = decodedData.map((item) => DailyFiguresDto.fromJson(item)).toList();

          // Populate styleList with styles not present in completedStyleList
          styleList = dailyFiguresDto!.map((item) => item.style).where((style) => !completedStyleList.contains(style)).toList();

          if (styleList.isNotEmpty) {
            _selectedStyle = styleList[0];
          }

        } else {
          clearFields();
        }
      } else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data: $e');
    }

    setState(() {}); // Trigger a rebuild to update the UI
  }



  //method for load data based on the lineNo

  Future<void> loadData() async {
    adjustTickAndFieldToEnable();
    disablefieldsAndButtons();
    clearFields();
    actualTotalPcs=0;
    try {
      print("Hello ${_selectedStyle}");
      //final response = await http.get(Uri.parse('${API.apiUrl}api/dailyfiguresbylinedatestyle?lineNo=$_selectedLineNo&date=$formattedDate&style=${_selectedStyle}'));
      //final response = await http.get(Uri.parse('${API.apiUrl}api/dailyfiguresbylinedatenstylelineNo?=$_selectedLineNo&date=$formattedDate&style=$_selectedStyle'));
      final response = await http.get(Uri.parse('${API.apiUrl}api/dailyfiguresbylinedatenstylefactorylineNo?lineNo=${_selectedLineNo}&date=${formattedDate}&style=$_selectedStyle&factory=${UserDetailRouting.factory}'));

      print("This is the result ${response.body}");

      if (response.statusCode == 200) {

        // If the server returns a 200 OK response, parse the data
        final List<dynamic> decodedData = json.decode(response.body);



        if (decodedData.isNotEmpty) {

          dailyFiguresDto = decodedData.map((item) => DailyFiguresDto.fromJson(item)).toList();

          //String style=dailyFiguresDto![0].style;
          //styleTextController.text = '${dailyFiguresDto![0].style}';
          // for(int i=0;i<dailyFiguresDto!.length;i++){
          //
          //   styleList!.add(dailyFiguresDto![i].style);
          //   print(styleList![i].toString());
          //
          // }
          quantityTextController.text = '${dailyFiguresDto![0].qty}';
          moTextController.text = '${dailyFiguresDto![0].mo}';
          helpTextController.text = '${dailyFiguresDto![0].hel}';
          ironTextController.text = '${dailyFiguresDto![0].iron}';
          forecastPcsTextController.text = '${dailyFiguresDto![0].forecastPcs}';
          smvTextController.text = '${dailyFiguresDto![0].smv}';

          //add data to the daily data model
          dailyFigures.date = selectedDate;
          dailyFigures.branchId=UserDetailRouting.factory;
          dailyFigures.style = dailyFiguresDto![0].style;
          dailyFigures.lineNo=dailyFiguresDto![0].lineNo;
          dailyFigures.poNo = dailyFiguresDto![0].poNo;
          dailyFigures.qtyRange =dailyFiguresDto![0].qtyRange;
          dailyFigures.qty = dailyFiguresDto![0].qty;
          dailyFigures.mo = dailyFiguresDto![0].mo;
          dailyFigures.hel = dailyFiguresDto![0].hel;
          dailyFigures.iron = dailyFiguresDto![0].iron;
          dailyFigures.smv = dailyFiguresDto![0].smv;
          dailyFigures.wMin = dailyFiguresDto![0].wMin;
          dailyFigures.forecastPcs = dailyFiguresDto![0].forecastPcs;


          adjustTickAndFieldToEnable();
          loadHourlyData();




          //efficiencyData = decodedData.map((item) => EfficiencyDtoGet.fromJson(item)).toList();


          // Create the indexToStyleMap


        } else {
          clearFields();

        }
      } else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data In Load Data: $e');
    }

    setState(() {}); // Trigger a rebuild to update the UI
  }

  //method for get hourlydata based on the factory date line and style

  Future<void> loadHourlyData() async {

    disablefieldsAndButtons();
    try {
      //final response = await http.get(Uri.parse('${API.apiUrl}api/hourlyfigures'));
      //final response = await http.get(Uri.parse('${API.apiUrl}api/hourlyfiguresbylinedatefactorystyle?lineNo=$_selectedLineNo&date=$formattedDate&style=${styleTextController.text}&factory=${UserDetailRouting.factory}'));

      print("Style : ${_selectedStyle}");
      print("Date : ${formattedDate}");
      print("Factory : ${_selectedBranch}");
      print("Line : ${_selectedLineNo}");

      final response = await http.get(Uri.parse('${API.apiUrl}api/hourlyfiguresbylinedatefactorystyle?lineNo=$_selectedLineNo&date=$formattedDate&style=${_selectedStyle}&factory=${UserDetailRouting.factory}'));


      if (response.statusCode == 200) {

        // If the server returns a 200 OK response, parse the data
        final List<dynamic> decodedData = json.decode(response.body);

        //print("AWAAAAAAAA ${decodedData.length}");
        if (decodedData.isNotEmpty) {
          //print("AWAAAAAAAA");
          hourlyFiguresDto = decodedData.map((item) => HourlyFiguresDto.fromJson(item)).toList();

          for(int i=0;i<hourlyFiguresDto!.length;i++){
            //print("Hourly Data List : ${hourlyFiguresDto![i].hourslot}");
            if(hourlyFiguresDto![i].hourslot =="1st"){
              time01Controller.text = "${hourlyFiguresDto![i].hourQty}";



            }
            if(hourlyFiguresDto![i].hourslot =="2nd"){
              time02Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="3rd"){
              time03Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="4th"){
              time04Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="5th"){
              time05Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="6th"){
              time06Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="7th"){
              time07Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="8th"){
              time08Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="9th"){
              time09Controller.text = "${hourlyFiguresDto![i].hourQty}";

            }
            if(hourlyFiguresDto![i].hourslot =="10th"){
              time10Controller.text = "${hourlyFiguresDto![i].hourQty}";


            }


          }

          //String style=dailyFiguresDto![0].style;


          //efficiencyData = decodedData.map((item) => EfficiencyDtoGet.fromJson(item)).toList();


          // calTotoal and dispaly on the total textfield
          calTotalPcs();


        } else {
          print("No data available for the given date and line");
          time01Controller.clear();
          time02Controller.clear();
          time03Controller.clear();
          time04Controller.clear();
          time05Controller.clear();
          time06Controller.clear();
          time07Controller.clear();
          time08Controller.clear();
          time09Controller.clear();
          time10Controller.clear();



          dailyFiguresDto = null;
        }
      } else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load dataaaaaaaaa: $e');
    }

    setState(() {}); // Trigger a rebuild to update the UI
  }



  //add data to hourlyData to the db
  Future<void> addData(

      DateTime date,
      String branchId,
      int lineNo,
      String style,
      int hourQty,
      String hourSlot
      ) async {

    // Constructing the DailyFiguresDto
    HourlyFiguresDto dailyFiguresDto = HourlyFiguresDto.fromJson({
      'date': date.toIso8601String(),
      'branch_id': branchId,
      'line_no': lineNo,
      'style': style,
      'hourqty':hourQty,
      'hourslot':hourSlot

    });

    try {

      // Convert efficiencyDto to a Map
      Map<String, dynamic> jsonData = dailyFiguresDto.toJson();

      // Send a POST request to your Node.js server to insert data into the database
      final response = await http.post(
        Uri.parse('${API.apiUrl}hourlyfigures'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 201) {
        //print('Data inserted successfully');
        print('Data added successfully. Inserted row ID: $response');
        _showSnackBar('Data added successfully');



      }else if(response.statusCode == 500){
        print('Failed to insert data. Line Duplicated ${response.body}');
        _showSnackBar('Already Completed the Hour');
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

  //add data to the efficiency Data table
  Future<void> addDataToEfficiency(
      DateTime date,
      String selectedBranch,
      String style,
      int selectedLine,
      String poNo,
      int qty,
      int mo,
      int hel,
      int iron,
      double smv,
      double cm,
      int forecastPcs,
      double forecastSah,
      double forecastEff,

      int actualPcs,
      double actualSah,
      double actualEff,
      double income) async {
    EfficiencyDtoSend efficiencyDto = EfficiencyDtoSend.fromJson({
      'date': date,
      'branch_id': selectedBranch,
      'line_no': selectedLine,
      'style': style,
      'po_no': poNo,
      'qty': qty,
      'mo': mo,
      'hel': hel,
      'iron': iron,
      'smv': smv,
      'cm': cm,
      'forcast_pcs': forecastPcs,
      'forcast_sah': forecastSah,
      'forcast_eff': forecastEff,
      'actual_pcs': actualPcs,
      'actual_sah': actualSah,
      'actual_eff': actualEff,
      'income': income,
    });

    try {
      // Convert efficiencyDto to a Map
      Map<String, dynamic> jsonData = efficiencyDto.toJson();

      // Send a POST request to your Node.js server to insert data into the database
      final response = await http.post(
        Uri.parse('${API.apiUrl}efficiency'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 201) {
        //print('Data inserted successfully');
        print('Data added successfully. Inserted row ID: $response');
        _showSnackBar('Data added successfully');


      }else if(response.statusCode == 500){
        print('Failed to insert data. Style Duplicated');
        _showSnackBar('Fail to insert data with Duplicated Style');
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

  //clear all fields
  void clearFields(){
    styleTextController.clear();
    quantityTextController.clear();
    moTextController.clear();
    helpTextController.clear();
    ironTextController.clear();
    forecastPcsTextController.clear();
    smvTextController.clear();
    dailyFiguresDto = null;

    //clear pcs text
    time01Controller.clear();
    time02Controller.clear();
    time03Controller.clear();
    time04Controller.clear();
    time05Controller.clear();
    time06Controller.clear();
    time07Controller.clear();
    time08Controller.clear();
    time09Controller.clear();
    time10Controller.clear();
  }
  //handle tick color and field enable
  void adjustTickAndFieldToEnable(){

    time01Controller.text="";
    isFieldEnabled1=true;
    tickColor1=Colors.green;

    time02Controller.text="";
    isFieldEnabled2=true;
    tickColor2=Colors.green;

    time03Controller.text="";
    isFieldEnabled3=true;
    tickColor3=Colors.green;

    time04Controller.text="";
    isFieldEnabled4=true;
    tickColor4=Colors.green;

    time05Controller.text="";
    isFieldEnabled5=true;
    tickColor5=Colors.green;


    time06Controller.text="";
    isFieldEnabled6=true;
    tickColor6=Colors.green;

    time07Controller.text="";
    isFieldEnabled7=true;
    tickColor7=Colors.green;

    time08Controller.text="";
    isFieldEnabled8=true;
    tickColor8=Colors.green;


    time09Controller.text="";
    isFieldEnabled9=true;
    tickColor9=Colors.green;

    time10Controller.text="";
    isFieldEnabled10=true;
    tickColor10=Colors.green;

    totalPcsController.text="";


  }

  //disable button and text fields
  void disablefieldsAndButtons(){

    DateTime currentDate = DateTime.now();

    DateTime time01 = DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 30);
    DateTime time02 = DateTime(currentDate.year, currentDate.month, currentDate.day, 10, 20);
    DateTime time03 = DateTime(currentDate.year, currentDate.month, currentDate.day, 11, 15);
    DateTime time04 = DateTime(currentDate.year, currentDate.month, currentDate.day, 12, 20);
    DateTime time05 = DateTime(currentDate.year, currentDate.month, currentDate.day, 13, 35);
    DateTime time06 = DateTime(currentDate.year, currentDate.month, currentDate.day, 14, 30);
    DateTime time07 = DateTime(currentDate.year, currentDate.month, currentDate.day, 15, 25);
    DateTime time08 = DateTime(currentDate.year, currentDate.month, currentDate.day, 16, 35);
    DateTime time09 = DateTime(currentDate.year, currentDate.month, currentDate.day, 17, 30);
    DateTime time10 = DateTime(currentDate.year, currentDate.month, currentDate.day, 18, 30);

    if(_currentTime.isAfter(time01)){
      isButtonEnabled1 =false;
      isFieldEnabled1=false;
    }
    if(_currentTime.isAfter(time02)){
      isButtonEnabled2 =false;
      isFieldEnabled2=false;
    }
    if(_currentTime.isAfter(time03)){
      isButtonEnabled3 =false;
      isFieldEnabled3 = false;
    }
    if(_currentTime.isAfter(time04)){
      isButtonEnabled4 =false;
      isFieldEnabled4 = false;
    }
    if(_currentTime.isAfter(time05)){
      isButtonEnabled5 =false;
      isFieldEnabled5 = false;
    }
    if(_currentTime.isAfter(time06)){
      isButtonEnabled6 =false;
      isFieldEnabled6 = false;
    }
    if(_currentTime.isAfter(time07)){
      isButtonEnabled7 =false;
      isFieldEnabled7 = false;
    }
    if(_currentTime.isAfter(time08)){
      isButtonEnabled8 =false;
      isFieldEnabled8 = false;
    }
    if(_currentTime.isAfter(time09)){
      isButtonEnabled9 =false;
      isFieldEnabled9 = false;
    }
    if(_currentTime.isAfter(time10)){
      isButtonEnabled10 =false;
      isFieldEnabled10 = false;
    }

  }


  //Calculate TotaluptoNow
  void calTotalPcs(){


    actualTotalPcs = 0;
    if(time01Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time01Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time02Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time02Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time03Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time03Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time04Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time04Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time05Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time05Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time06Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time06Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time07Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time07Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time08Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time08Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time09Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time09Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    if(time10Controller.text.isNotEmpty){
      actualTotalPcs+=int.parse(time10Controller.text);
    }else{
      actualTotalPcs+=0;
    }
    totalPcsController.text = actualTotalPcs.toString();
    print("Total Count is  ${actualTotalPcs}");
  }


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // print(_currentTime.second);
    // int chour = _currentTime.hour;
    // int cmin = _currentTime.minute;
    //
    // if(chour>7 && cmin>8){
    //   print("Done and Dusted");
    // }
    Color myColor = Color(0xFF000035);

    //print("User Email +${factory}");
    //print("User Factory +${UserDetailRouting.factory}");
    return Scaffold(
      body: Container(

        color: myColor,


        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: myColor,
                ),
                height: height* 0.25,
                width: width,
                //child: SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(

                        padding: const EdgeInsets.only(
                          top: 35,
                          left: 15,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                _showModalBottomSheet(context);
                              },
                              child: Icon(
                                Icons.sort,
                                color: Colors.orange,
                                size: 40.0,

                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: 50,
                                width: 50,

                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage('assets/icons/lady_40px.png')
                                    )
                                ),

                              ),
                              onTap: (){
                                _showModalBottomSheetUser(context);
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Select ${UserDetailRouting.factory}'s Line No",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white,
                                fontSize: width/30,
                              ),
                            ),
                            DropdownButton<String>(
                              value: _selectedLineNo,
                              dropdownColor: myColor,
                              hint: Text('Select Line No',style: TextStyle(color: Colors.white,fontSize:width/30),),

                              items: _lineNumbersByBranch[UserDetailRouting.factory ?? '']?.map((lineNo) {
                                return DropdownMenuItem<String>(
                                  value: lineNo,
                                  child: Text(lineNo,style: TextStyle(color: Colors.white,fontSize: width/30),),
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

                                  loadStyles();
                                  styleList.clear();
                                  totalPcsController.text="";



                                });

                              },
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date : ${formattedDate}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white38,
                                fontSize: width/30,
                              ),
                            ),

                            Text(
                              'Time : ${_currentTime.hour} : ${_currentTime.minute} : ${_currentTime.second}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white,
                                fontSize: width/25,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.black26,
                          Colors.lightBlueAccent,

                        ]
                    )

                ),
                height: height * 0.72,
                width: width,
                child: Container(
                  //height: doubl,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15,left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(

                                "Style No:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              SingleChildScrollView(
                                child: Container(
                                    //width: ,


                                  child: DropdownButton<String>(
                                    value: _selectedStyle, // Initially selected value (null by default)
                                    dropdownColor: myColor,
                                    icon: Icon(Icons.arrow_drop_down), // Dropdown icon
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: width/30), // Dropdown text style
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedStyle = newValue;
                                        loadData();


                                        // Update selected value when dropdown changes

                                      });
                                      // calTotalPcs();
                                      // totalPcsController.text = actualTotalPcs.toString();
                                    },
                                    items: styleList.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value, // Value of the dropdown item
                                        child: Text(value), // Text to display in the dropdown menu
                                      );
                                    }).toList(),
                                  ),

                                ),
                              ),
                              SizedBox(width: 30,),
                              Text(
                                "Order Qty:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                    controller: quantityTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      _qtyText = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: '2000',
                                      hintStyle: TextStyle(color: Colors.grey)


                                      ,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(

                                "Mo:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 20,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white,fontSize: width/25, fontWeight: FontWeight.bold),
                                    controller: moTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      //= value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: '25',
                                      hintStyle: TextStyle(color: Colors.grey)

                                      ,
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                "Help:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                    controller: helpTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      //_qtyText = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: '2000',
                                      hintStyle: TextStyle(color: Colors.grey)


                                      ,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Iron:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                    controller: ironTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      // _qtyText = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: '2000',
                                      hintStyle: TextStyle(color: Colors.grey)


                                      ,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(

                                "Forecast Pcs:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 120,
                                  child: TextField(
                                    style: TextStyle(color: Colors.red,fontSize: width/25,fontWeight: FontWeight.bold),
                                    controller: forecastPcsTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      // _forcastPcsText = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: 'ST001',
                                      hintStyle: TextStyle(color: Colors.grey)

                                      ,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,),
                              Text(
                                "SMV",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white38,
                                  fontSize: width/25,
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Container(
                                  width: 50,
                                  child: TextField(
                                    style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                    controller: smvTextController,
                                    enabled: false,

                                    onChanged: (value) {
                                      //_qtyText = value;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //hintText: '2000',
                                      hintStyle: TextStyle(color: Colors.grey)


                                      ,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                        ),
                        Divider(color: Colors.white,thickness: 4,),
                        SingleChildScrollView(

                          child: Container(

                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "1st Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold,),
                                            controller: time01Controller,

                                            onChanged: (value) {

                                            },
                                            enabled: isFieldEnabled1,
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled1 ?(){
                                            try{


                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time01Controller.text), "1st");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");

                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor1,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "2nd Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time02Controller,


                                            onChanged: (value) {

                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled2 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time02Controller.text), "2nd");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor2,)),


                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "3rd Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled3,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time03Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled3 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time03Controller.text), "3rd");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor3,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "4th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled4,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time04Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled4 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time04Controller.text), "4th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor4,)),


                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "5th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled5,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time05Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled5 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time05Controller.text), "5th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor5,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "6th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled6,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time06Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled6 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time06Controller.text), "6th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor6,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "7th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled7,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time07Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled7 ?(){
                                            try{

                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(),int.parse(time07Controller.text), "7th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();

                                            }catch(e){
                                                print("AWLAK : $e wtj% ${_selectedStyle}");
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor7,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "8th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled8,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time08Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled8 ?(){
                                            try{
                                              print(time08Controller.text);
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time08Controller.text), "8th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor8,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "9th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled9,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time09Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),
                                      ElevatedButton(
                                          onPressed: isButtonEnabled9 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time09Controller.text), "9th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor9,)),



                                    ],
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "10th Hour :",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(
                                            keyboardType: TextInputType.number, // Restrict input to numeric keyboard
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly // Allow only digits (numbers)
                                            ],
                                            enabled: isFieldEnabled10,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: time10Controller,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(

                                              hintText: 'Enter Pcs',
                                              hintStyle: TextStyle(color: Colors.grey)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),

                                      ElevatedButton(
                                          onPressed: isButtonEnabled10 ?(){
                                            try{
                                              addData(selectedDate, UserDetailRouting.factory, int.parse(_selectedLineNo.toString()), _selectedStyle.toString(), int.parse(time10Controller.text), "10th");
                                              calTotalPcs();
                                              totalPcsController.text = actualTotalPcs.toString();
                                            }catch(e){
                                              _showSnackBar("Please select Ongoing Line No,Style or Enter PCS");
                                            }
                                          }:null,
                                          child: Icon(Icons.done_outline_outlined,color: tickColor10,)),



                                    ],
                                  ),

                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 40),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(

                                        "Total Pcs",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white,
                                          fontSize: width/25,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          width: 60,
                                          child: TextField(

                                            enabled: false,
                                            style: TextStyle(color: Colors.white,fontSize: width/25,fontWeight: FontWeight.bold),
                                            controller: totalPcsController,


                                            onChanged: (value) {
                                              // _forcastPcsText = value;
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,

                                              hintText: '0',
                                              hintStyle: TextStyle(color: Colors.red)

                                              ,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 30,),

                                      ElevatedButton(
                                        onPressed: (){

                                          // calTotalPcs();
                                          // //hourlyFiguresDto = decodedData.map((item) => HourlyFiguresDto.fromJson(item)).toList();
                                          // print("Hello This is data : ${actualTotalPcs}");
                                          // calculateEfficiencyTableData.calculateEfficiencyData(dailyFigures,actualTotalPcs);
                                          // totalPcsController.text=actualTotalPcs.toString();
                                          // actualTotalPcs=0;
                                          showSessionEndConfirmationDialog(context);

                                        },
                                        child: Text("End Session",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        style: ButtonStyle(
                                          backgroundColor:MaterialStateProperty.all<Color>(Colors.green),
                                        ),
                                      ),



                                    ],
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 32.0,
        backgroundColor: AppColors.blueDark,
        color: Colors.white38,

        items: <Widget>[
          Icon(Icons.home, size: 15),
          Icon(Icons.list, size: 15),
          Icon(Icons.settings, size: 15),
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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext builderContext) {
        return Container(
          //height: 300.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(Icons.question_answer_outlined,color: Colors.purple,),
                    title: Text(
                      'Help/ FAQs',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Handle "View All Factories"
                      Navigator.pop(builderContext);
                    },
                  ),
                  //Divider(),
                  ListTile(
                    leading: Icon(Icons.phone,color: Colors.green,),
                    title: Text(
                      'Contact Us',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),

                    ),
                    onTap: () {
                      // Handle "Contact Us"
                      Navigator.pop(builderContext);
                    },
                  ),
                  //Divider(),

                  //Divider(),
                  ListTile(
                    leading: Icon(Icons.details,color: Colors.yellow,),
                    title: Text(
                      'About Us',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Handle "Log Out"
                      Navigator.pop(builderContext);
                    },
                  ),
                  //Divider(),
                  ListTile(
                    leading: Icon(Icons.settings,color: Colors.black,),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Handle "Log Out"
                      Navigator.pop(builderContext);
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.red,),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Navigate to the Dashboard page
                      // Show confirmation dialog
                      showLogoutConfirmationDialog(context);

                    },

                  ),
                  // Add more options as needed
                ],
              ),
            ),
          ),

        );

      },
    );
  }

  void _showModalBottomSheetUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext builderContext) {
        return Container(
          //height: 300.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(Icons.email,color: Colors.purple,),
                    title: Text(
                      'User Factory : ${UserDetailRouting.factory}',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Handle "View All Factories"
                      Navigator.pop(builderContext);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email,color: Colors.purple,),
                    title: Text(
                      'User Email : ${UserDetailRouting.userEmail}',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Handle "View All Factories"
                      Navigator.pop(builderContext);
                    },
                  ),
                  Divider(),


                  ListTile(
                    leading: Icon(Icons.exit_to_app,color: Colors.red,),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                    onTap: () {
                      // Navigate to the Dashboard page
                      // Show confirmation dialog
                      showLogoutConfirmationDialog(context);

                    },

                  ),
                  // Add more options as needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Log Out'),
          content: Text('Are you sure to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action, e.g., navigate to login page
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }


  void showSessionEndConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm End Session'),
          content: Text('Are you sure to End The Session?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                calTotalPcs();
                //hourlyFiguresDto = decodedData.map((item) => HourlyFiguresDto.fromJson(item)).toList();
                print("Hello This is data : ${actualTotalPcs}");
                EfficiencyInterTransferDto efficiencyInterTransferDto = calculateEfficiencyTableData.calculateEfficiencyData(dailyFigures,actualTotalPcs);
                totalPcsController.text=actualTotalPcs.toString();
                actualTotalPcs=0;

                //call the addDataEfficiency
                addDataToEfficiency(efficiencyInterTransferDto.date,
                  efficiencyInterTransferDto.branchId,
                  efficiencyInterTransferDto.style,
                  efficiencyInterTransferDto.lineNo,
                  efficiencyInterTransferDto.poNo,
                  efficiencyInterTransferDto.qty,
                  efficiencyInterTransferDto.mo,
                  efficiencyInterTransferDto.hel,

                  efficiencyInterTransferDto.iron,
                  efficiencyInterTransferDto.smv,
                  double.parse(efficiencyInterTransferDto.cm.toStringAsFixed(2)),
                  efficiencyInterTransferDto.forecastPcs,
                  double.parse(efficiencyInterTransferDto.forecastSah.toStringAsFixed(2)),
                  double.parse(efficiencyInterTransferDto.forecastEff.toStringAsFixed(2)),
                  efficiencyInterTransferDto.actualPcs,
                  double.parse(efficiencyInterTransferDto.actualSah.toStringAsFixed(2)),
                  double.parse(efficiencyInterTransferDto.actualEff.toStringAsFixed(2)),
                  double.parse(efficiencyInterTransferDto.income.toStringAsFixed(2)),
                );




                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HourlyDataNew()),
                );

              },
              child: Text('End'),
            ),
          ],
        );
      },
    );
  }
}
