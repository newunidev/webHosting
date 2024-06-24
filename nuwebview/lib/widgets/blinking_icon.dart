import 'package:flutter/material.dart';

class BlinkingIcon extends StatefulWidget {
  final double cumalative;


  const BlinkingIcon({
    Key? key,
    required this.cumalative,
     }) : super(key: key);

  @override
  _BlinkingIconState createState() => _BlinkingIconState();
}

class _BlinkingIconState extends State<BlinkingIcon> with SingleTickerProviderStateMixin {
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
    //double valueToShow = widget.cumalative > 0 ? widget.cumalative / widget.remainingHours : 0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${widget.cumalative.toStringAsFixed(2)}"),
            if (widget.cumalative > 0)
              Opacity(
                opacity: _controller.value,
                child: Text("  !", style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold)),
              ),
          ],
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
