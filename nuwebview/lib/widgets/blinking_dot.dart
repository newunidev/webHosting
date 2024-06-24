import 'package:flutter/material.dart';

class BlinkingDot extends StatefulWidget {
  final Color? dotColor; // Optional color parameter

  const BlinkingDot({Key? key, required this.dotColor}) : super(key: key);

  @override
  _BlinkingDotState createState() => _BlinkingDotState();
}
class _BlinkingDotState extends State<BlinkingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Icon(
          Icons.offline_bolt,
          color: widget.dotColor!.withOpacity(_controller.value),
          size: 30.0,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}