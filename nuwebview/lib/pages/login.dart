import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


import '../const/api.dart';
import '../const/const_data.dart';
import '../const/login_user_routes.dart';
import '../const/ui_constant.dart';
import '../controller/DatabaseController.dart';
import 'admin_dashboard.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController adminPswController = TextEditingController();

  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSqlLiteUsers();
  }

  void getAllSqlLiteUsers() async{

    List<Map<String, dynamic>> users = await databaseHelper.getAllUsers();

    // Print all users
    users.forEach((user) {
      //print('Email: ${user['email']}, Password: ${user['password']}');
      usernameController.text = user['email'];

    });
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyle(color: Colors.red,fontSize: 13),),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  //get userFactory
  Future<void> getUserToGivenEmail(String userEmail) async {
    try {
      final response = await http.get(Uri.parse('${API.apiUrl}api/userFactory?email=$userEmail'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the 'factory' value from the JSON
        String factory = responseData['factory'];

        // Update the state with the fetched factory value
        UserDetailRouting.factory = factory;


      } else {
        print('Failed to fetch users. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error during API request: $e');
    }
  }



  //method for login check
  Future<String?> loginUser(String email, String password) async {

    try {
      final response = await http.post(
        Uri.parse('${API.apiUrl}login'), // Replace with your actual authentication endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {

        final Map<String, dynamic> responseData = json.decode(response.body);

        // Assuming the backend sends a 'token' key in the response
        final String? jwtToken = responseData['token'];

        print(" Response Data is $responseData");
        if (jwtToken != null) {

          // Authentication successful
          UserDetailRouting.userEmail =usernameController.text.toString();
          getUserToGivenEmail(UserDetailRouting.userEmail);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Dashboard()),
          // );

          int result = await databaseHelper.saveUser(email, "password");
          print("resulut is : ${result}");

          _showLoadingIndicator();
          await Future.delayed(Duration(seconds: 3));

          // Navigate to the dashboard after the delay
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );

          return jwtToken;
        } else {
          // Token not present in the response

          return null;
        }
      } else {
        //print(response.body+'${response.statusCode}');
        _showSnackBar(response.body);
        // Authentication failed
        return null;

      }
    } catch (e) {
      // Handle network or other errors
      print('Error during authentication: $e');

      _showSnackBar('Error connecting to the server. Please check your internet connection.');

      return null;
    }
  }
  void _showLoadingIndicator() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Logging in...'),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    Color myColor = Color(0xFF000035);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(

          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [AppColors.blueDark,AppColors.blueDark,AppColors.blueDark],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(color: AppColors.yellowGold, fontSize: 40.0,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome Back",
                      style: TextStyle(color: AppColors.yellowGold, fontSize: 18.0,fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 60.0),
                      Container(
                        width: ConstData.deviceScreenWidth/1.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellowGold,//Color.fromRGBO(69, 39, 160, 0.8),
                              blurRadius: 20,
                              offset: Offset(0, 15),
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!))),
                              child: TextField(
                                controller: usernameController,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "User Name / Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[300]!))),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        child: Text(
                          "Forgot Passowrd ?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () => showContactConfirmationDialog(context),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        onTap: (){
                           // Navigator.push(
                           //    context,
                           //    MaterialPageRoute(builder: (context) => Dashboard()),
                           //  );
                          loginUser(usernameController.text,passwordController.text);

                        },
                        child: Container(
                          width: ConstData.deviceScreenWidth/1.5,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 70),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.blueDark,
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: AppColors.yellowGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ConstData.deviceScreenWidth/24),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      GestureDetector(
                        child: Text(
                          "Create Account ?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () => showContactConfirmationDialog(context),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(

                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.g_mobiledata,
                                      color: Colors.white,

                                    ),
                                    SizedBox(width: 6,),
                                    Text(
                                      "Google",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Icon(
                                      Icons.call,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6,),
                                    GestureDetector(
                                      child: Text(
                                        "Admin Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),


                                      ),
                                      onTap: () {
                                        print("AWA");
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Enter Verification Code'),
                                              content: TextField(
                                                obscureText: true,
                                                controller: adminPswController,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  hintText: 'Verification Code',
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Check the verification code
                                                    if (adminPswController.text == '1234@nu') {
                                                      // Code is correct, navigate to admin dashboard
                                                      Navigator.of(context).pop(); // Close the dialog
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => AdminDashboard()),

                                                      );
                                                      FocusScope.of(context).unfocus();
                                                    } else {
                                                      _showSnackBar("Verification Code Invalid");
                                                      // Incorrect code, show an error or retry
                                                      // For simplicity, just print an error here
                                                      //print('Incorrect verification code');
                                                    }
                                                  },
                                                  child: Text('Verify'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },

                                    ),



                                  ],
                                ),

                              ),

                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void showContactConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password / New Account'),
          content: Text('Please Do Contact +9477000000'),
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
                Navigator.of(context).pop();
                launchUrlString('tel:+94720429424');
              },
              child: Text('Call'),
            ),
          ],
        );
      },
    );
  }
}
