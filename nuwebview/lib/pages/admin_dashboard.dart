import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuwebview/pages/view_users.dart';



import 'add_new_user2.dart';

import 'alter_users.dart';
import 'hourly_data_new.dart';
import 'login.dart';



class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {


  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());


  var height,width;

  //details for the list view icons and titles

  List imageData = [
    'assets/icons/addUser.png',
    'assets/icons/view.png',
    'assets/icons/update.png',
    'assets/icons/update.png',



  ];

  List titles =[
    "Add New User",
    "View Users",
    "Alter Users",
    "Monthly Target"

  ];


  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.deepPurple,
        
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
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
                                color: Colors.orange,
                                size: 40.0,
                          
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                          
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
                                color:Colors.orange,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date : ${formattedDate}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white38,
                                fontSize: 18.0,
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

                  //borderRadius: BorderRadius.all(Radius.circular(15)),

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
                  itemCount:imageData.length,
                  itemBuilder: (context,index){
                    return Container(

                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,//fromRGBO(225, 95, 27, 0.3),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: InkWell(
                        onTap: (){
                          if(index == 0){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewUser2(),
                              ),
                            );
                          }else if(index == 1){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewUsers(),
                              ),
                            );
                          }else if(index == 2){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlterUser()//DailyEfficiencyChart(),
                              ),
                            );
                          }else if(index == 3){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HourlyDataNew()//DailyEfficiencyChart(),
                              ),
                            );
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

                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
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
