import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
  });
  final void Function() onPressed;
  final double? width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width ?? 60,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: child,
    );
  }
}
