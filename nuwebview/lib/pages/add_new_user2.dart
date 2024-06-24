import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:http/http.dart' as http;

import '../const/api.dart';
import 'admin_dashboard.dart';




class AddNewUser2 extends StatefulWidget {
  const AddNewUser2({super.key});

  @override
  State<AddNewUser2> createState() => _AddNewUser2State();
}

class _AddNewUser2State extends State<AddNewUser2> {
  var height,width;
  String? _selectedBranch = 'Bakamuna Factory';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final List<String> _branches = [
    'Bakamuna Factory',
    'Hettipola Factory',
    'Mathara Factory',
    'Piliyandala Factory',
    'Welioya Factory',
    'Admin'


  ];

  void navigateToAddNewForm() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AddNewUser2()),

    );
  }

  Future<void> registerUser(
      String email,
      String password,
      String firstName,
      String lastName

      ) async{
    // UserSendDto userSendDto = UserSendDto.fromJson(
    //     {
    //       'email' : email,
    //       'password_hash' : password,
    //       'first_name' : firstName,
    //       'last_name' : lastName,
    //     }
    // );
    try {
      // Convert efficiencyDto to a Map
      print('Branche :${_selectedBranch}');

      // Send a POST request to your Node.js server to insert data into the database
      final response = await http.post(
        Uri.parse('${API.apiUrl}register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'factory': _selectedBranch
        }),
      );

      if (response.statusCode == 201) {
        //print('Data inserted successfully');
        print('Data added successfully. Inserted row ID: $response');
        _showSnackBar('Data added successfully');
        navigateToAddNewForm();



      } if(response.statusCode == 409){
        _showSnackBar('User Already Exist');
      }else {
        print('Failed to insert data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        _showSnackBar('Fail to insert data with status code ${response.statusCode}');



      }
    } catch (e) {
      print('Error during data insertion: $e');
      // Handle error accordingly
      _showSnackBar("$e");
    }


  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;




    return Scaffold(
      body:Container(
        color: Colors.deepPurple,


        child: SingleChildScrollView(
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

                                  
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/3.5),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome to NU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.orange,
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
                            Text(
                              'Register New User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:Colors.white38,
                                fontSize: width/20,
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
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.grey,
                        Colors.lightBlueAccent
                      ]
                  )

                ),
                height: height * 0.75,
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(

                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(

                        margin: const EdgeInsets.all(24.0),
                        child: Column(
                          children: <Widget>[

                            TextFormField(
                              maxLength: 100,
                              controller: emailController,
                              decoration: InputDecoration(hintText: 'Email',hintStyle: TextStyle(color: Colors.black,fontSize: width/25)),
                              validator: (value) {
                                // Email validation using a regular expression
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                // Regular expression for a valid email address
                                String emailRegex =
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                                RegExp regex = RegExp(emailRegex);
                                if (!regex.hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null; // Return null if the input is valid
                              },

                              onSaved: (value){

                              },
                            ),
                            SizedBox(height: height/35,),

                            TextFormField(
                              maxLength: 100,
                              controller: passwordController,
                              decoration: InputDecoration(hintText: 'Password',hintStyle: TextStyle(color: Colors.black,fontSize: width/25)),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }

                                // Regular expression for a strong password:
                                // At least 8 characters, at least one uppercase letter, at least one lowercase letter,
                                // at least one digit, and at least one special character
                                // RegExp passwordRegex = RegExp(
                                //   r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&*!])[A-Za-z\d@#$%^&*!]{8,}$',
                                // );
                                //
                                // if (!passwordRegex.hasMatch(value)) {
                                //   return 'Password must be strong';
                                // }
                                //
                                // return null; // Return null if the input is valid
                              },
                            ),
                            SizedBox(height: height/35,),
                            TextFormField(
                              maxLength: 30,
                              controller: firstNameController,
                              decoration: InputDecoration(hintText: 'First Name',hintStyle: TextStyle(color: Colors.black,fontSize: width/25)),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First Name is required';
                                }

                                return null; // Return null if the input is valid
                              },
                            ),
                            SizedBox(height: height/35,),
                            TextFormField(
                              maxLength: 30,
                              controller: lastNameController,
                              decoration: InputDecoration(hintText: 'Last Name',hintStyle: TextStyle(color: Colors.black,fontSize: width/25)),

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last Name is required';
                                }

                                return null; // Return null if the input is valid
                              },
                            ),
                            SizedBox(height: height/35,),
                            DropdownButtonFormField<String>(
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
                                  // You can perform additional actions when the branch is selected
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a branch';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 50,),
                            Container(
                              child: ElevatedButton(
                                child: Text('Save'),
                                onPressed: (){
                                 if(_formKey.currentState!.validate()){

                                   print("Email ${emailController.text}");
                                   print("password ${passwordController.text}");
                                   print("first Name ${firstNameController.text}");
                                   print("Last Name ${lastNameController.text}");
                                   print("Factory ${_selectedBranch}");

                                   registerUser(emailController.text, passwordController.text, firstNameController.text, lastNameController.text);
                                 }


                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                builder: (context) =>  AdminDashboard(),
              ),
            );
          }
        },
      ),
    );
  }
}
