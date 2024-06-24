import 'package:flutter/material.dart';

class BlinkingExclamationCell extends StatefulWidget {
  final int difference;
  final int remainingHours;

  const BlinkingExclamationCell({
    Key? key,
    required this.difference,
    required this.remainingHours,
  }) : super(key: key);

  @override
  _BlinkingExclamationCellState createState() => _BlinkingExclamationCellState();
}

class _BlinkingExclamationCellState extends State<BlinkingExclamationCell> with SingleTickerProviderStateMixin {
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
    double valueToShow = widget.difference > 0 ? widget.difference / widget.remainingHours : 0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, Widget? child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${valueToShow.toStringAsFixed(0)}"),
            if (widget.difference > 0)
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
