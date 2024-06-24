

import 'package:flutter/material.dart';

class CircularFabMenu extends StatefulWidget {
  const CircularFabMenu({super.key});

  @override
  State<CircularFabMenu> createState() => _CircularFabMenuState();
}

class _CircularFabMenuState extends State<CircularFabMenu> {

  final double buttonSize = 80.0;
  @override
  Widget build(BuildContext context) => Flow(
    delegate: FlowMenuDelegate(),
    children: <IconData>[
      Icons.mail,
      Icons.call,
      Icons.notification_add,
      Icons.sms,
      Icons.menu,
    ].map<Widget>(buildFAB).toList(),
  );

  Widget buildFAB(IconData icon) => SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: FloatingActionButton(

      onPressed: (){},
      elevation: 0,
      splashColor: Colors.black,
      child: Icon(icon, color: Colors.white, size: 45),

    ),
  );
}

class FlowMenuDelegate extends FlowDelegate{
  @override
  void paintChildren(FlowPaintingContext context){
    context.paintChild(0);

  }

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) => false;
}
