import 'dart:convert';
import 'dart:math';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:nuwebview/pages/landscape_hourly_check.dart';


import '../const/api.dart';
import '../const/const_data.dart';
import '../controller/factory_selector.dart';
import '../model/EfficiencyDtoGet.dart';
import '../widgets/flexible_space_app_bar.dart';
import 'dashboard.dart';

//pdf imports
//pdf
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'dart:io';
import 'package:open_file/open_file.dart';

class AllDataNew extends StatefulWidget {
  const AllDataNew({super.key});

  @override
  State<AllDataNew> createState() => _AllDataNewState();
}

class _AllDataNewState extends State<AllDataNew> {
  var height,width;
  FactorySelector factorySelector = FactorySelector();

  //List<Map<String, dynamic>>? efficiencyData;
  List<EfficiencyDtoGet> efficiencyList = [];
  //EfficiencyDtoGet efficiencyDtoGet = EfficiencyDtoGet();

  List<EfficiencyDtoGet> filteredList = [];

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    loadData(); // Load data here
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }


  Future<void> generateEfficiencyPDF(List<EfficiencyDtoGet> efficiencyList) async {
    final pdf = pdfWidgets.Document();

    // Create a list to store the rows
    final List<pdfWidgets.TableRow> tableRows = [];

    // Add headers
    tableRows.add(pdfWidgets.TableRow(
      children: [
        for (var column in [
          'STYLE',
          'DATE',
          'BRANCH NAME',
          'Line No',
          'PO No',
          'Qty',
          'MO',
          'HEL',
          'Iron',
          'SMV',
          'CM',
          'Forecast PCS',
          'Forecast SAH',
          'Forecast EFF',
          'Actual PCS',
          'Actual SAH',
          'Actual EFF',
          'Income',
        ])
          pdfWidgets.Container(
            padding: pdfWidgets.EdgeInsets.all(5),
            child: pdfWidgets.Text(
              column,
              style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold, fontSize: 8.0),
            ),
          ),
      ],
    ));

    // Add data rows
    for (final EfficiencyDtoGet efficiency in efficiencyList) {
      final List<String> rowValues = [
        efficiency.style,
        DateFormat('yyyy-MM-dd').format(efficiency.date.toLocal()),
        efficiency.branchId,
        efficiency.lineNo.toString(),
        efficiency.poNo,
        efficiency.qty.toString(),
        efficiency.mo.toString(),
        efficiency.hel.toString(),
        efficiency.iron.toString(),
        efficiency.smv.toString(),
        efficiency.cm.toString(),
        efficiency.forecastPcs.toString(),
        efficiency.forecastSah.toString(),
        (efficiency.forecastEff * 100).toStringAsFixed(2),
        efficiency.actualPcs.toString(),
        efficiency.actualSah.toString(),
        (efficiency.actualEff * 100).toStringAsFixed(2),
        efficiency.income.toString(),
      ];

      final List<pdfWidgets.Widget> rowWidgets = rowValues.map((value) => pdfWidgets.Container(
        padding: pdfWidgets.EdgeInsets.all(5),
        child: pdfWidgets.Text(
          value,
          style: pdfWidgets.TextStyle(fontSize: 5.0),
        ),
      )).toList();

      tableRows.add(pdfWidgets.TableRow(
        children: rowWidgets,
      ));
    }

    // Add the total MO count row
    final List<String> totalRowValues = [
      'Total',
      '',
      '',
      '',
      '',
      '',
      '${getTotalMOCount(efficiencyList)}',
      '${getTotalHelpCount(efficiencyList)}',
      '${getTotalIronCount(efficiencyList)}',
      '',
      '',
      '${getTotalForecastPCS(efficiencyList)}',
      '${getTotalForecastSAH(efficiencyList).toStringAsFixed(2)}',
      '${getTotalForecastEfficiency(efficiencyList).toStringAsFixed(2)}',
      '${getTotalActualPcs(efficiencyList)}',
      '${getTotalActualSah(efficiencyList).toStringAsFixed(2)}',
      '${getTotalActualEfficiency(efficiencyList).toStringAsFixed(2)}',
      'USD: ${getTotalIncome(efficiencyList).toStringAsFixed(2)}',
    ];

    final List<pdfWidgets.Widget> totalRowWidgets = totalRowValues.map((value) => pdfWidgets.Container(
      padding: pdfWidgets.EdgeInsets.all(5),
      child: pdfWidgets.Text(
        value,
        style: pdfWidgets.TextStyle(fontWeight: pdfWidgets.FontWeight.bold, fontSize: 5.0),
      ),
    )).toList();

    tableRows.add(pdfWidgets.TableRow(
      children: totalRowWidgets,
    ));

    // Build the PDF table
    final pdfTable = pdfWidgets.Table(
      columnWidths: {
        for (int i = 0; i < 18; i++) i: pdfWidgets.FixedColumnWidth(300), // Adjust column widths as needed
      },
      defaultVerticalAlignment: pdfWidgets.TableCellVerticalAlignment.middle,
      border: pdfWidgets.TableBorder.all(),
      children: tableRows,
    );

    // Add the PDF table to the document
    pdf.addPage(pdfWidgets.Page(
      orientation: pdfWidgets.PageOrientation.landscape,
      build: (context) => pdfTable,
    ));

    final directory = await getExternalStorageDirectory();
    final documentsDirectory = Directory('${directory!.path}/Documents');

    // Create the 'Documents' directory if it doesn't exist
    if (!await documentsDirectory.exists()) {
      await documentsDirectory.create(recursive: true);
    }

    final filePath = '${documentsDirectory.path}/efficiency_example.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(filePath); // Open the PDF file after saving

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved at: $filePath'),
      ),
    );
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
          // Sort dailyFiguresList according to the line_no column
          efficiencyList.sort((a, b) => a.lineNo.compareTo(b.lineNo));
          filteredList = List.from(efficiencyList);
          filteredList.sort((a, b) => a.lineNo.compareTo(b.lineNo));
          for (var efficiency in efficiencyList) {
            //print(efficiency.date);
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

  //calculate total MO Count
  int getTotalMOCount(List<EfficiencyDtoGet> data) {
    // Create a set to store unique line numbers
    Set<int> uniqueLines = Set<int>();
    // Iterate over the data and add unique line numbers to the set
    for (final efficiency in data) {
      uniqueLines.add(efficiency.lineNo);
    }
    // Initialize total MO count
    int totalMO = 0;
    // Iterate over the unique line numbers and sum up the MO count for each unique line
    for (int lineNo in uniqueLines) {
      // Check if the line number has been counted already
      bool counted = false;
      // Iterate over the data and check if the line number matches the current unique line
      for (final efficiency in data) {
        if (efficiency.lineNo == lineNo && !counted) {
          // If the line number matches and it hasn't been counted already, add its MO count to the total
          totalMO += efficiency.mo;
          counted = true; // Set counted to true to prevent double counting
        }
      }
    }
    return totalMO;
  }


  //calculate total HElP Count
  int getTotalHelpCount(List<EfficiencyDtoGet> data) {
    // Create a set to store unique line numbers
    Set<int> uniqueLines = Set<int>();
    // Iterate over the data and add unique line numbers to the set
    for (final efficiency in data) {
      uniqueLines.add(efficiency.lineNo);
    }
    // Initialize total MO count
    int totalHelp = 0;
    // Iterate over the unique line numbers and sum up the MO count for each unique line
    for (int lineNo in uniqueLines) {
      // Check if the line number has been counted already
      bool counted = false;
      // Iterate over the data and check if the line number matches the current unique line
      for (final efficiency in data) {
        if (efficiency.lineNo == lineNo && !counted) {
          // If the line number matches and it hasn't been counted already, add its MO count to the total
          totalHelp += efficiency.hel;
          counted = true; // Set counted to true to prevent double counting
        }
      }
    }
    return totalHelp;
  }

  //calculate total IRON Count
  int getTotalIronCount(List<EfficiencyDtoGet> data) {
    // Create a set to store unique line numbers
    Set<int> uniqueLines = Set<int>();
    // Iterate over the data and add unique line numbers to the set
    for (final efficiency in data) {
      uniqueLines.add(efficiency.lineNo);
    }
    // Initialize total MO count
    int totalIron = 0;
    // Iterate over the unique line numbers and sum up the MO count for each unique line
    for (int lineNo in uniqueLines) {
      // Check if the line number has been counted already
      bool counted = false;
      // Iterate over the data and check if the line number matches the current unique line
      for (final efficiency in data) {
        if (efficiency.lineNo == lineNo && !counted) {
          // If the line number matches and it hasn't been counted already, add its MO count to the total
          totalIron += efficiency.hel;
          counted = true; // Set counted to true to prevent double counting
        }
      }
    }
    return totalIron;
  }

  //calculate the totalForcastPcs
  int getTotalForecastPCS(List<EfficiencyDtoGet> data){

    int totalForecastPcs = 0;
    for(final efficiency in data){
      totalForecastPcs += efficiency.forecastPcs;
    }
    return totalForecastPcs;

  }

  //calculate the totalForecastSAH
  double getTotalForecastSAH(List<EfficiencyDtoGet> data){

    double totalForecastSah = 0;
    for(final efficiency in data){
      totalForecastSah += efficiency.forecastSah;
    }
    return totalForecastSah;

  }
  //calculate the totalForecastEfficiency
  double getTotalForecastEfficiency(List<EfficiencyDtoGet> data){

    double totalForecastEfficiency = 0;
    for(final efficiency in data){
      totalForecastEfficiency += efficiency.forecastEff*100;
    }
    return totalForecastEfficiency;

  }

  //calculate the totalActualPCS
  int getTotalActualPcs(List<EfficiencyDtoGet> data){

    int totalActualPcs = 0;
    for(final efficiency in data){
      totalActualPcs += efficiency.actualPcs;
    }
    return totalActualPcs;

  }

  //calculate the totalActualSah
  double getTotalActualSah(List<EfficiencyDtoGet> data){

    double totalActualSah = 0;
    for(final efficiency in data){
      totalActualSah += efficiency.actualSah;
    }
    return totalActualSah;

  }

  //calculate the totalActualEfficiency
  double getTotalActualEfficiency(List<EfficiencyDtoGet> data){

    double totalActualEfficiency = 0;
    for(final efficiency in data){
      totalActualEfficiency += efficiency.actualEff*100;
      print('Efficiency Value : ${totalActualEfficiency}');
    }
    return totalActualEfficiency;

  }

  //calculate the totalIncome
  double getTotalIncome(List<EfficiencyDtoGet> data){
    double totalIncome = 0;
    for (final efficiency in data) {
      totalIncome += efficiency.income;
    }
    return totalIncome;
  }


  // Function to generate a random color
  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    Color myColor = Color(0xFF2D1A42);

    final uniqueLineNos = filteredList.map((e) => e.lineNo).toSet().toList();
    // Generate a color for each unique line number
    final lineNoColors = Map<int, Color>.fromIterable(
      uniqueLineNos,
      key: (item) => item,
      value: (item) => _generateRandomColor(),
    );
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
                                      loadData(); // Reload data when the date is changed
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
                                        fontSize: height/25,
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
                                      hint: Text('Select Branch',style: TextStyle(color: Colors.white,fontSize: height/25),),
                                      items: factorySelector.setFactoryOnUser().map((branch) {
                                        return DropdownMenuItem<String>(
                                          value: branch,
                                          child: Text(branch),
                                        );
                                      }).toList(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: height/25,
                                      ),
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedFactory = newValue;
                                            loadData();

                                            //if condition for checking month selection

                                            // Reload data when the factory is changed
                                          });
                                        }
                                      },
                                    ),
                                    // child: DropdownButton<String>(
                                    //   value: factorySelector.setFactoryOnUserString(),
                                    //   hint:const Text("Select Factory", style: TextStyle(color: Colors.white),),
                                    //   borderRadius:BorderRadius.circular(10.0),
                                    //   icon: Icon(Icons.factory_rounded,color: Colors.red,),
                                    //
                                    //
                                    //   dropdownColor: myColor,
                                    //   // decoration: InputDecoration(
                                    //   //   filled: true,
                                    //   //   fillColor: Colors.white,
                                    //   //   hintText: 'Select Branch',
                                    //   //   //contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    //   //   border: OutlineInputBorder(
                                    //   //     borderRadius: BorderRadius.circular(10.0),
                                    //   //   ),
                                    //   //   enabledBorder: OutlineInputBorder(
                                    //   //     borderSide: BorderSide(color: Colors.black),
                                    //   //     borderRadius: BorderRadius.circular(10.0),
                                    //   //   ),
                                    //   //   // focusedBorder: OutlineInputBorder(
                                    //   //   //   borderSide: BorderSide(color: Colors.white),
                                    //   //   //   borderRadius: BorderRadius.circular(10.0),
                                    //   //   // ),
                                    //   // ),
                                    //   items: factorySelector.setFactoryOnUser().map((branch) {
                                    //     return DropdownMenuItem<String>(
                                    //       value: branch,
                                    //       child: Text(
                                    //         branch,
                                    //         style: TextStyle(color: Colors.white, fontSize: width/25,fontWeight: FontWeight.bold),
                                    //       ),
                                    //     );
                                    //   }).toList(),
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       selectedFactory = value;
                                    //       loadData();
                                    //     });
                                    //   },
                                    // ),
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
                              columnSpacing: width/200,

                              dividerThickness: 2,
                              headingRowHeight: 70,
                              border: TableBorder.all(width: 1.0, color: Colors.grey),
                              columns: [
                                DataColumn(label: Text('STYLE',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('DATE',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('BRANCH NAME',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Line No',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('PO No',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Qty',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('MO',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('HEL',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Iron',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('SMV',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('CM',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Forecast PCS',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Forecast SAH',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Forecast EFF',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Actual PCS',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Actual SAH',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Actual EFF',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                                DataColumn(label: Text('Income',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18.0))),
                              ],
                              rows: [
                                ...filteredList.map((efficiency) {
                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                                      // Coloring logic based on the lineNo value
                                      return lineNoColors[efficiency.lineNo]!.withOpacity(0.8);
                                    }),
                                    cells: [
                                      DataCell(Text(efficiency.style)),
                                      DataCell(Text(DateFormat('yyyy-MM-dd').format(efficiency.date.toLocal()))),
                                      DataCell(Text(efficiency.branchId)),
                                      DataCell(Text(efficiency.lineNo.toString())),
                                      DataCell(Text(efficiency.poNo)),
                                      DataCell(Text(efficiency.qty.toString())),
                                      DataCell(Text(efficiency.mo.toString())),
                                      DataCell(Text(efficiency.hel.toString())),
                                      DataCell(Text(efficiency.iron.toString())),
                                      DataCell(Text(efficiency.smv.toString())),
                                      DataCell(Text(efficiency.cm.toString())),
                                      DataCell(Text(efficiency.forecastPcs.toString())),
                                      DataCell(Text(efficiency.forecastSah.toString())),
                                      DataCell(Text((efficiency.forecastEff * 100).toStringAsFixed(2) + ' %')),
                                      DataCell(Text(efficiency.actualPcs.toString())),
                                      DataCell(Text(efficiency.actualSah.toString())),
                                      DataCell(Text((efficiency.actualEff * 100).toStringAsFixed(2) + ' %')),
                                      DataCell(Text(efficiency.income.toString())),
                                    ],
                                  );
                                }).toList(),
                                DataRow(cells: [
                                  DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('${getTotalMOCount(efficiencyList)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalHelpCount(efficiencyList)}')),
                                  DataCell(Text('${getTotalIronCount(efficiencyList)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('')),
                                  DataCell(Text('')),
                                  DataCell(Text('${getTotalForecastPCS(efficiencyList)}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalForecastSAH(efficiencyList).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalForecastEfficiency(efficiencyList).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalActualPcs(efficiencyList)}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalActualSah(efficiencyList).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('${getTotalActualEfficiency(efficiencyList).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text('USD: ${getTotalIncome(efficiencyList).toStringAsFixed(2)}', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),
                                ]),
                              ],


                            ),
                          ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  LandscapeViewHourlyData(),
              ),
            );
          }
        },
      ),
    );

  }
}
