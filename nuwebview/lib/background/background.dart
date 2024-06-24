import 'package:flutter/material.dart';

import '../const/ui_constant.dart';



class BackgroundImage extends StatelessWidget {
  final Widget child;

  const BackgroundImage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color selection3 = Colors.deepPurple[300]!;
    Color selection2 = Colors.orange[600]!;
    Color selection1 = Colors.deepPurple[900]!;
    Color myColor = AppColors.blueDark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [myColor, myColor, myColor]),
        // image: DecorationImage(
        //
        //   image: AssetImage('assets/images/background1.jpg'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: child,
    );

  }
}

