import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';



import '../const/api.dart';
import 'admin_dashboard.dart';

class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {



  List<Map<String, dynamic>> users = [];



  Future<void> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse('${API.apiUrl}api/users'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> fetchedUsers = json.decode(response.body);

        // Update the state with fetched user details
        setState(() {
          users = fetchedUsers.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API request: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('First Name')),
            DataColumn(label: Text('Last Name')),
            DataColumn(label: Text('Factory')),
          ],
          rows: users
              .map(
                (user) => DataRow(
              cells: [
                DataCell(Text('${user['id']}')),
                DataCell(Text('${user['email']}')),
                DataCell(Text('${user['first_name']}')),
                DataCell(Text('${user['last_name']}')),
                DataCell(Text('${user['factory']}')),
              ],
            ),
          )
              .toList(),
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
}
