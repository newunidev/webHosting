import 'package:flutter/material.dart';

class FlexibleSpaceAppBar extends StatelessWidget {
  const FlexibleSpaceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  FlexibleSpaceBar(
      background: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.deepPurple[900]!,
              Colors.orange[600]!,
              Colors.deepPurple[300]!,

            ],
          ),
        ),
      ),
    );
  }
}
