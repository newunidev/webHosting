import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;



import '../const/api.dart';
import '../const/const_data.dart';
import '../controller/factory_selector.dart';
import '../model/EfficiencyDtoGet.dart';
import '../model/LineStyleDto.dart';
import '../model/TargetHoulryDataDto.dart';
import '../widgets/BlinkingExclamation.dart';
import '../widgets/blinking_dot.dart';
import '../widgets/flexible_space_app_bar.dart';
import 'dashboard.dart';

//pdf imports
//pdf
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'dart:io';
import 'package:open_file/open_file.dart';

class ViewHourlyData extends StatefulWidget {
  const ViewHourlyData({super.key});

  @override
  State<ViewHourlyData> createState() => _ViewHourlyDataState();
}

class _ViewHourlyDataState extends State<ViewHourlyData> {
  var height,width;
  FactorySelector factorySelector = FactorySelector();
  Color tableColumnColor =Colors.black;
  Color blinkingDotColor1 = Colors.green;
  Color blinkingDotColor2 = Colors.green;
  Color blinkingDotColor3 = Colors.green;
  Color blinkingDotColor4 = Colors.green;
  Color blinkingDotColor5 = Colors.green;
  Color blinkingDotColor6 = Colors.green;
  Color blinkingDotColor7 = Colors.green;
  Color blinkingDotColor8 = Colors.green;
  Color blinkingDotColor9 = Colors.green;
  Color blinkingDotColor10 = Colors.green;



  //time tanges
  late Timer _timer;
  //late Timer _autoRefreshTime;
  late DateTime _currentTime = DateTime.now();
  int remainingHours = 10;

  //table configurations
  List<int> lineNumbers = [];
  List<String> styles = [];

  //List<Map<String, dynamic>>? efficiencyData;
  List<EfficiencyDtoGet> efficiencyList = [];
  //EfficiencyDtoGet efficiencyDtoGet = EfficiencyDtoGet();

  List<EfficiencyDtoGet> filteredList = [];
  List<TargetHourlyDto> hourlyData = [];


  TextEditingController searchController = TextEditingController();




  DateTime selectedDate = DateTime.now();
  String? selectedFactory; // Default factory
  //List<EfficiencyDTORetrieve>? efficiencyData;
  List<String> uniqueStyles = [];
  List<String> uniqueLines = [];
  Map<int, String> indexToStyleMap = {};
  Map<int, String> indexToLineMap = {};

  List<String> _branches = [
    'Bakamuna Factory',
    'Hettipola Factory',
    'Mathara Factory',
    'Piliyandala Factory',
    'Welioya Factory',
  ];


  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();

    // Start the first timer for updating every second
    _startFirstTimer();

    // Start the second timer for updating every two minutes
    _startSecondTimer();
   //loadData(); // Load data here
  }
  void _startFirstTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          setColorsForTheBlinkingDot();
        });
      }
    });
  }

  void _startSecondTimer() {
    Timer.periodic(Duration(seconds: 60), (timer) {

      if (mounted) {
        setState(() {
          print("Hello Activate ");
          fetchLineStyles();
        });
      }
    });
  }
  @override
  void dispose() {
    // It's important to cancel the timer when the widget is disposed
    // to prevent memory leaks.
    print("I am Here On Dispose");
    _timer?.cancel();



    super.dispose();

  }


  //setColors for the blinking dot
  void setColorsForTheBlinkingDot(){

    DateTime currentDate = DateTime.now();
    remainingHours =10;


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
      blinkingDotColor1 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time02)){
      blinkingDotColor2 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time03)){
      blinkingDotColor3 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time04)){
      blinkingDotColor4 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time05)){
      blinkingDotColor5 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time06)){
      blinkingDotColor6 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time07)){
      blinkingDotColor7 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time08)){
      blinkingDotColor8 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time09)){
      blinkingDotColor9 = Colors.white;
      --remainingHours;
    }
    if(_currentTime.isAfter(time10)){
      blinkingDotColor10 = Colors.white;

    }
    print("Remaining Hours : ${remainingHours}");
  }

 //method to load styles and lines related to them
  Future<void> fetchLineStyles() async {
    print("Hey I am here");
    try {
      //print("Datess :${selectedDate}");
      final response = await http.get(Uri.parse('${API.apiUrl}api/linestylesbydatefactory?date=$selectedDate&factory=$selectedFactory'));


      //api for springframework api requests.
      //final response = await http.get(Uri.parse('http://192.168.1.149:8080/api/branchDate?date=${selectedDate}&branch_id=$selectedFactory'));



      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<LineStyleDto> lineStyles = data.map((item) => LineStyleDto(item['line_no'], item['style'],item['po'])).toList();
        if(lineNumbers.isEmpty){
          hourlyData = [];
        }
        print("Length Of Line Numbers : ${lineStyles.length}");
        for(int i=0;i<lineStyles.length;i++){
          fetchHourlyDataToTabel(lineStyles[i].style,lineStyles[i].lineNo);
          print("Data Line Number is ${lineStyles[i].lineNo} Style : ${lineStyles[i].style}");

          //print("Data Style Number is ${lineStyles[i].lineNo}");
        }

        // Now `lineStyles` is populated with your API data
        // You can use setState() to update your UI or however else you need to use the data
      }else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        print("Unable To Load Data");
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        print("Unable To Load Data");
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        print("Unable To Load Data");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data: $e');
    }




    //var response = await http.get(url);


  }

  Future<void> fetchHourlyDataToTabel(String passedStyle,int passedLineNo) async {
    int hour1 = 0;
    int hour2 = 0;
    int hour3 = 0;
    int hour4 = 0;
    int hour5 = 0;
    int hour6 = 0;
    int hour7 = 0;
    int hour8 = 0;
    int hour9 = 0;
    int hour10 = 0;
    int sumOfHourQty = 0;


    hourlyData = [];
    TargetHourlyDto hourlyDto = new TargetHourlyDto();
    try {
      //print("Datess :${selectedDate}");
      final response = await http.get(Uri.parse('${API.apiUrl}api/hourlydataforviewtargetbydatefactorystyleline?date=$selectedDate&factory=$selectedFactory&style=$passedStyle&lineNo=$passedLineNo'));


      if (response.statusCode == 200) {

        List<dynamic> data = json.decode(response.body);

        //print("Hello${passedStyle}");


        for (var item in data) {
           
          int hourQty = item['hourqty'];

          String hourSlot = item['hourslot'];


          // Initialize values for TargetHourlyDto



          // Add more variables for other hours as needed

          // Set values based on hour slot
          switch (hourSlot) {
            case '1st':
              hour1 = hourQty;
              break;
            case '2nd':
              hour2 = hourQty;
              break;
            case '3rd':
              hour3 = hourQty;
              break;
            case '4th':
              hour4 = hourQty;
              break;
            case '5th':
              hour5 = hourQty;
              break;
            case '6th':
              hour6 = hourQty;
              break;
            case '7th':
              hour7 = hourQty;
              break;
            case '8th':
              hour8 = hourQty;
              break;
            case '9th':
              hour9 = hourQty;
              break;
            case '10th':
              hour10 = hourQty;
              break;
          // Add cases for other hour slots as needed
          }

          //set Data to the TargetHourlyDto
          hourlyDto.lineNo =item['line_no'] ;
          hourlyDto.mo =item['mo'];
          hourlyDto.help =item['hel'];
          hourlyDto.iron =item['iron'];
          hourlyDto.style =item['style'];
          hourlyDto.smv =double.parse(item['smv'].toString());
          hourlyDto.hour1 =hour1;
          hourlyDto.hour2 =hour2;
          hourlyDto.hour3 =hour3;
          hourlyDto.hour4 =hour4;
          hourlyDto.hour5 =hour5;
          hourlyDto.hour6 =hour6;
          hourlyDto.hour7 =hour7;
          hourlyDto.hour8 =hour8;
          hourlyDto.hour9 =hour9;
          hourlyDto.hour10 =hour10;
          hourlyDto.forecastPcs =item['forcast_pcs'];
          //calculate total qty upto now
          sumOfHourQty = hour1 +hour2 +hour3 +hour4 +hour5 +hour6 +hour7 +hour8 +hour9 +hour10;
          hourlyDto.total =sumOfHourQty;
          hourlyDto.difference =int.parse(item['forcast_pcs'].toString())-sumOfHourQty;


          // Add the new TargetHourlyDto to the hourlyData list


        }
        setState(() {
          hourlyData.add(hourlyDto);
        });
        //print("Data For the table is : ${hourlyData}");
        //print("Length of HourlyData list ${hourlyData.length}");

        // Now `lineStyles` is populated with your API data
        // You can use setState() to update your UI or however else you need to use the data
      }else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        print("Unable To Load Data");
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        print("Unable To Load Data");
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        print("Unable To Load Data");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data: $e');
    }



  }




//search feature
  void _filterData(String searchTerm) {
    setState(() {
      filteredList = efficiencyList.where((efficiency) {
        return efficiency.style.toLowerCase().contains(searchTerm.toLowerCase()) ||
            efficiency.poNo.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    });
  }

  Future<void> loadData() async {

    try {
      //print("Datess :${selectedDate}");

      final response = await http.get(Uri.parse('${API.apiUrl}api/branchDate?date=$selectedDate&branchId=$selectedFactory'));

      //api for springframework api requests.
      //final response = await http.get(Uri.parse('http://192.168.1.149:8080/api/branchDate?date=${selectedDate}&branch_id=$selectedFactory'));



      if (response.statusCode == 200) {

        // If the server returns a 200 OK response, parse the data
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          efficiencyList = data.map((item) => EfficiencyDtoGet.fromJson(item)).toList();
          filteredList = List.from(efficiencyList);
          for (var efficiency in efficiencyList) {
            print(DateFormat('yyyy-MM-dd HH:mm:ss').format(efficiency.date.toLocal()));
          }
        });
      } else if (response.statusCode == 400) {
        // If the server returns a 400 Bad Request response, handle the error
        print("Unable To Load Data");
        throw Exception('Bad Request: ${json.decode(response.body)['error']}');
      } else if (response.statusCode == 500) {
        // If the server returns a 500 Internal Server Error response, handle the error
        print("Unable To Load Data");
        throw Exception('Internal Server Error');
      } else {
        // Handle other status codes if needed
        print("Unable To Load Data");
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during data loading: $e');
      // Handle other exceptions if needed
      throw Exception('Failed to load data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xFF2D1A42);

    return Scaffold(
      body:Container(
        color: myColor,


        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: myColor,
                ),
                height: height * 0.25,
                width: width,
                child: SingleChildScrollView(
                  //physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(

                        padding: const EdgeInsets.only(
                          top: 25,
                          left: 15,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                //_showModalBottomSheet(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.orange,
                                size: 20.0,

                              ),
                            ),
                            Container(
                              height: 30,
                              width: 30,

                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: AssetImage('assets/icons/lady_40px.png')
                                  )
                              ),


                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top : 0,
                          left: 13,
                          //bottom: 30
                          //right: 15,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //padding: const EdgeInsets.symmetric(vertical: 1),
                              child: TextButton(
                                onPressed: () async {
                                  final DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (pickedDate != null && pickedDate != selectedDate) {
                                    setState(() {
                                      uniqueStyles = [];
                                      selectedDate = pickedDate;
                                      fetchLineStyles();
                                      //loadData(); // Reload data when the date is changed
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size:40.0,
                                      color: Colors.white, // Adjust the color as needed
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: width*.04,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            // Dropdown to select factory
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 10,
                                      //bottom: 40

                                    ),
                                    child: DropdownButton<String>(
                                      value: selectedFactory,//factorySelector.setFactoryOnUserString(),
                                      dropdownColor: Colors.black,
                                      hint: const Text('Select Branch',style: TextStyle(color: Colors.white),),
                                      items: factorySelector.setFactoryOnUser().map((branch) {
                                        return DropdownMenuItem<String>(
                                          value: branch,
                                          child: Text(branch),
                                        );
                                      }).toList(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: ConstData.deviceScreenWidth/25,
                                      ),
                                      onChanged: (String? newValue) {

                                        if (newValue != null) {
                                          setState(() {
                                            selectedFactory = newValue;
                                            fetchLineStyles();
                                            //loadData();

                                            //if condition for checking month selection

                                            // Reload data when the factory is changed
                                          });
                                        }
                                      },
                                    ),

                                  ),
                                  SizedBox(height: 12.0),
                                  Container(
                                    height: ConstData.deviceScreenHeight/12,

                                    width: ConstData.deviceScreenWidth/3,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(225, 95, 27, 0.3),
                                          blurRadius: 40,
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        _filterData(value);
                                      },
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        hintText: "Search Here",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

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
                  // gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     colors: [
                  //       Colors.black26,
                  //       Colors.lightBlueAccent
                  //     ]
                  // )

                ),
                height: height * 0.75,
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,

                  child: Column(
                    children: [
                      Container(

                        child: Padding(

                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Row(children: [Text('Line No',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 8,),],)),
                                DataColumn(label: Text('Mo',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),)),
                                DataColumn(label: Text('Help',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),)),
                                DataColumn(label: Text('Iron',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),)),
                                DataColumn(label: Text('Style',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),)),
                                DataColumn(label: Text('SMV',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),)),
                                DataColumn(label: Row(

                                  children: [
                                    Text('1',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor1,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('2',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor2,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('3',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor3,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('4',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor4,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('5',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor5,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('6',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor6,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('7',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor7,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('8',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor8,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('9',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor9,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('10',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),BlinkingDot(dotColor: blinkingDotColor10,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('Forecast Qty',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('Total',style: TextStyle(color: tableColumnColor,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,),
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('Difference',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,)
                                  ],
                                )),
                                DataColumn(label: Row(
                                  children: [
                                    Text('Required Rate',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 20.0),),SizedBox(width: 5,)
                                  ],
                                )),
                                // Add more DataColumn widgets for additional fields
                              ],
                              rows: hourlyData.map((TargetHourlyDto) {


                                return DataRow(cells: [
                                  DataCell(Text(TargetHourlyDto.lineNo.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                                  DataCell(Text(TargetHourlyDto.mo.toString())),
                                  DataCell(Text(TargetHourlyDto.help.toString())),
                                  DataCell(Text(TargetHourlyDto.iron.toString())),
                                  DataCell(Text(TargetHourlyDto.style.toString(),)),
                                  DataCell(Text(TargetHourlyDto.smv.toString())),
                                  DataCell(Text(TargetHourlyDto.hour1.toString())),
                                  DataCell(Text(TargetHourlyDto.hour2.toString())),
                                  DataCell(Text(TargetHourlyDto.hour3.toString())),
                                  DataCell(Text(TargetHourlyDto.hour4.toString())),
                                  DataCell(Text(TargetHourlyDto.hour5.toString())),
                                  DataCell(Text(TargetHourlyDto.hour6.toString())),
                                  DataCell(Text(TargetHourlyDto.hour7.toString())),
                                  DataCell(Text(TargetHourlyDto.hour8.toString())),
                                  DataCell(Text(TargetHourlyDto.hour9.toString())),
                                  DataCell(Text(TargetHourlyDto.hour10.toString())),
                                  DataCell(Text(TargetHourlyDto.forecastPcs.toString())),
                                  DataCell(Text(TargetHourlyDto.total.toString())),
                                  DataCell(Text(TargetHourlyDto.difference.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                                  DataCell(BlinkingExclamationCell(difference: TargetHourlyDto.difference, remainingHours: remainingHours)),





                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //    // await generateEfficiencyPDF(efficiencyList);
              //   },
              //   child: Text('Print'),
              // ),
            ],
          ),
        ),


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchLineStyles();
        },
        tooltip: 'Fetch Users',
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        height: 50.0,

        items: <Widget>[
          Icon(Icons.home, size: 20),
          Icon(Icons.list, size: 20),
          Icon(Icons.settings, size: 20),
        ],
        onTap: (index) {
          if(index == 0){
            Navigator.pop(context);
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
