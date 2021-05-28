import 'package:flutter/material.dart';

class BRBRCard extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback onTab;

  BRBRCard({this.child, this.padding = const EdgeInsets.all(0), this.backgroundColor, this.onTab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
        elevation: 15,
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        color: backgroundColor ?? Colors.white,
      ),
    );
  }
}
