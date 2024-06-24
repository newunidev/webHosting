import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckDropDown extends StatefulWidget {
  const CheckDropDown({super.key});

  @override
  State<CheckDropDown> createState() => _CheckDropDownState();
}

class _CheckDropDownState extends State<CheckDropDown> {
  String? _selectedFruit; // Variable to store the selected fruit

  // List of fruits for the dropdown menu
  final List<String> fruits = ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'];


  @override
  Widget build(BuildContext context) {
     return Scaffold(
       body:Container(
           alignment: Alignment.center,
         child: DropdownButton<String>(
           value: _selectedFruit, // Initially selected value (null by default)
           icon: Icon(Icons.arrow_drop_down), // Dropdown icon
           iconSize: 24,
           elevation: 16,
           style: TextStyle(color: Colors.deepPurple), // Dropdown text style
           underline: Container(
             height: 2,
             color: Colors.deepPurpleAccent,
           ),
           onChanged: (String? newValue) {
             setState(() {
               _selectedFruit = newValue; // Update selected value when dropdown changes
             });
           },
           items: fruits.map<DropdownMenuItem<String>>((String value) {
             return DropdownMenuItem<String>(
               value: value, // Value of the dropdown item
               child: Text(value), // Text to display in the dropdown menu
             );
           }).toList(),
         ),

       )
     );
  }
}
