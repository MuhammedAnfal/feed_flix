import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.bgColor,
    this.buttonHeight,
    this.buttonWidth,
    this.borderRadius = 20,
    required this.onPressed,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.borderColor,
  });

  final Color? bgColor, borderColor;
  final Function()? onPressed;
  final double? buttonHeight, buttonWidth, borderRadius;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth ?? 130,
      height: buttonHeight ?? 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? Colors.grey.shade700),
            borderRadius: BorderRadius.circular(borderRadius ?? 20),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
