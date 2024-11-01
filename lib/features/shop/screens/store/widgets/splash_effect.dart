import 'package:flutter/material.dart';

class SplashEffect extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final BorderRadius? borderRadius;

  const SplashEffect({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
