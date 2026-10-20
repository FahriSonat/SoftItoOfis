import 'package:flutter/material.dart';

class ResetPasswordCard extends StatelessWidget {
  final Widget child;

  const ResetPasswordCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
