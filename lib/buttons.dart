
//IM/2021/025 - Samarasingha D.A

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Color? color; // Allow nullable
  final Color? textColor; // Allow nullable
  final dynamic content; // Accepts either String or IconData
  final double borderRadius;
  final VoidCallback? buttonTapped;

  MyButton({
    this.color, // Nullable
    this.textColor, // Nullable
    required this.content,
    this.borderRadius = 50,
    this.buttonTapped,
  });

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true; // Set pressed state
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false; // Revert pressed state
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false; // Revert pressed state if tap is canceled
    });
  }

  @override
  Widget build(BuildContext context) {
    // Darken the button color if pressed
    final effectiveColor = _isPressed
        ? _darkenColor(widget.color ?? Colors.grey[800]!)
        : widget.color ?? Colors.grey[800]!;

    return GestureDetector(
      onTap: widget.buttonTapped,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0, // Scale effect for pressed state
        duration: Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: effectiveColor,
                boxShadow: _isPressed
                    ? [] // No shadow when pressed
                    : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(4, 6),
                  ),
                ],
              ),
              child: Center(
                child: widget.content is String
                    ? Text(
                  widget.content,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : Icon(
                  widget.content,
                  color: widget.textColor ?? Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to darken a color
  Color _darkenColor(Color color) {
    const double darkenFactor = 0.2; // How much darker to make the color
    return Color.fromRGBO(
      (color.red * (1 - darkenFactor)).round(),
      (color.green * (1 - darkenFactor)).round(),
      (color.blue * (1 - darkenFactor)).round(),
      1.0,
    );
  }
}
