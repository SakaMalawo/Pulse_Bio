import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Color? color;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = color ?? Colors.white.withOpacity(0.16);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: base,
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
