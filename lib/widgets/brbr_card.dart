import 'package:flutter/material.dart';

class BRBRCard extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;
  final Color backgroundColor;
  final VoidCallback? onTab;

  BRBRCard({required this.child, this.padding = const EdgeInsets.all(0), this.backgroundColor = Colors.white, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: backgroundColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTab,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
