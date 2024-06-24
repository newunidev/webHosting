import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



import '../const/const_data.dart';
import '../const/login_user_routes.dart';
import '../const/ui_constant.dart';
import '../controller/factory_selector.dart';
import '../model/DailyFigures.dart';
import 'all_data_new.dart';

import 'hourly_data_new.dart';

import 'landscape_hourly_check.dart';

import 'login.dart';




class Dashboard extends StatefulWidget {
  const Dashboard({super.key});


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  FactorySelector factorySelector = FactorySelector();


  var height,width;

  //details for the list view icons and titles

  List imageData = [
    'assets/icons/dailyNw.png',
    'assets/icons/hourly.png',
    'assets/icons/targetNw.png',
    'assets/icons/cost.png',
    'assets/icons/summery.png',
    'assets/icons/pieData.png',
    'assets/icons/efficiencyNw.png',
    'assets/icons/lineAnalysis.png',
    'assets/icons/factory.png',



  ];

  List titles =[
    "Daily Figures",
    "Hourly Data",
    "Target Board",
    "Cost Board",
    "Summery Icome",
    "Qty Analysis",
    "Summery Eff",
    "Line Analysis",
    "All Data"
  ];


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;



    Color myColor = Color(0xFF000035);
    //print("User Email +${factory}");
    //print("User Factory +${UserDetailRouting.factory}");
    return Scaffold(
      body: Container(

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
                                  color: AppColors.yellowGold,
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
                          padding: EdgeInsets.only(
                            top : 10,
                            left: 25,
                            //right: 15,

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to NU',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:AppColors.yellowGold,
                                  fontSize: width/30,
                                ),
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
                        Colors.lightBlueAccent
                      ]
                    )

                  ),
                  height: height * 0.75,
                  width: width,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 25,
                    ),
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: titles.length,


                    itemBuilder: (context,index){

                      //print("Image Data item 6 : ${imageData[6]}");
                      return InkWell(
                        onTap: (){
                          if(index == 0 && UserDetailRouting.factory.toString() != 'Admin'){
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => DailyFigures(),
                            //   ),
                            // );
                          }else if(index == 1 && UserDetailRouting.factory.toString() !="Admin"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HourlyDataNew()//TableView(),
                              ),
                            );
                          }else if(index == 2){
                            Navigator.push(
                                  context,
                                  MaterialPageRoute(

                                      builder: (context) => LandscapeViewHourlyData()//EfficiencyAnalysisNew(passedMonth: 1,passedBranch: UserDetailRouting.factory,passedDaysWorked: 1,passedTargetEfficiency: 1.0,)//DailyEfficiencyChart(),
                                  ),
                            );
                            // if(UserDetailRouting.factory != "Admin"){
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //
                            //         builder: (context) => AllDataNew()//EfficiencyAnalysisNew(passedMonth: 1,passedBranch: UserDetailRouting.factory,passedDaysWorked: 1,passedTargetEfficiency: 1.0,)//DailyEfficiencyChart(),
                            //     ),
                            //   );
                            // }else{
                            //   // Navigator.push(
                            //   //   context,
                            //   //   MaterialPageRoute(
                            //   //
                            //   //       builder: (context) => EfficiencyAnalysisNew(passedMonth: 1,passedBranch: "Hettipola Factory",passedDaysWorked: 1,passedTargetEfficiency: 1.0,)//DailyEfficiencyChart(),
                            //   //   ),
                            //   // );
                            // }

                          }else if(index == 3){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }
                          }else if(index == 4){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }

                          } else if(index == 5){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  //builder: (context) => LineQuantityBarChart(),
                                  builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }

                          }else if(index == 6){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }
                          }else if(index == 7){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => HourlyDataNew(),
                                ),
                              );
                            }

                          }else if(index == 8){
                            if(UserDetailRouting.factory != "Admin"){
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => AllDataNew()//DailyEfficiencyChart(),
                                ),
                              );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                    builder: (context) => AllDataNew()//DailyEfficiencyChart()7
                                ),
                              );
                            }
                          }


                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                ),
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imageData[index],
                                width: 100,


                              ),
                              Text(
                                titles[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(

                                  fontSize: ConstData.deviceScreenWidth/30,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
}
