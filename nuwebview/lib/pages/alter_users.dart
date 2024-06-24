import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nuwebview/pages/view_users.dart';


import '../const/api.dart';
import 'admin_dashboard.dart';

class AlterUser extends StatefulWidget {
  const AlterUser({super.key});

  @override
  State<AlterUser> createState() => _AlterUserState();
}

class _AlterUserState extends State<AlterUser> {

  List<Map<String,dynamic>> users = [];

  //to fetch the selectedUser from the tbale
  Map<String,dynamic>? selectedUser;

  //text field controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController adminPasswordController = TextEditingController();

  //get all users method

  Future<void> getAllUsers() async{

    try{
      final response = await http.get(Uri.parse('${API.apiUrl}api/users'));

      if(response.statusCode == 200){
        final List<dynamic> fetchedUsers = json.decode(response.body);

        setState(() {
          users = fetchedUsers.cast<Map<String,dynamic>>();
        });

      }else{
        print('Failed to fetch users. Status code: ${response.statusCode}');
      }

    }catch(e){
      print('Error during API request: $e');
    }


  }

  //delete selected user Method
  Future<void> deleteUser(String userId) async {
    final String apiUrl = '${API.apiUrl}deleteUser/$userId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // User deleted successfully
        print('User deleted successfully');
      } else if (response.statusCode == 404) {
        // User not found
        print('User not found ${response.body}');
      } else {
        // Handle other status codes or errors
        print('Error deleting user: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.black26,
              Colors.blueAccent
            ],
          ),
        ),
        child: Padding(

          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('First Name')),
                DataColumn(label: Text('Last Name')),
              ],
              rows: users
                  .map(
                    (user) => DataRow(
                  cells: [
                    DataCell(Text('${user['id']}')),
                    DataCell(Text('${user['email']}')),
                    DataCell(Text('${user['first_name']}')),
                    DataCell(Text('${user['last_name']}')),
                  ],
                  onSelectChanged: (selected) {
                    if (selected != null && selected) {
                      setState(() {
                         selectedUser = user;
                         emailController.text = selectedUser!['email'];
                         firstNameController.text = selectedUser!['first_name'];
                         lastNameController.text = selectedUser!['last_name'];
                         _showUserDetailsBottomSheet();

                      });
                          // You can add additional logic here if needed
                    }
                 },
                ),
              ) .toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getAllUsers();
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

  void _showUserDetailsBottomSheet() {
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Name',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter First Name',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.0), // Add spacing between the text fields
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Name',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter Last Name',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {


                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Enter Verification Code'),
                              content: TextField(
                                obscureText: true,
                                controller: adminPasswordController,
                                keyboardType: TextInputType.number,
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
                                    if (adminPasswordController.text == '1234@nu') {
                                      // Code is correct, navigate to admin dashboard
                                      // Navigator.of(context).pop(); // Close the dialog
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => AdminDashboard()),
                                      //
                                      // );
                                      print('Done and Dusted');
                                      FocusScope.of(context).unfocus();
                                    } else {
                                      // Incorrect code, show an error or retry
                                      // For simplicity, just print an error here
                                      print('Incorrect verification code');
                                    }
                                  },
                                  child: Text('Verify'),
                                ),
                              ],
                            );
                          },
                        );

                    },
                    child: Text('Update'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Enter Verification Code'),
                            content: TextField(
                              obscureText: true,
                              controller: adminPasswordController,
                              keyboardType: TextInputType.number,
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
                                  String userId = selectedUser!['id'].toString();
                                  // Check the verification code
                                  if (adminPasswordController.text == '1234@nu') {
                                    print(userId);
                                    deleteUser(selectedUser!['id'].toString());
                                    //Navigator.of(context).pop(); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => ViewUsers()),

                                    );
                                  } else {
                                    // Incorrect code, show an error or retry
                                    // For simplicity, just print an error here
                                    print('Incorrect verification code');
                                  }
                                },
                                child: Text('Verify'),
                              ),
                            ],
                          );
                        },
                      );

                    },
                    //style: ElevatedButton.styleFrom(primary: Colors.red),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


}
