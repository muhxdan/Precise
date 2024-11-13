import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconButton extends StatelessWidget {
  final String assets;
  final VoidCallback onTap;
  final Color? color;
  final double? size;

  const SvgIconButton({
    super.key,
    required this.assets,
    required this.onTap,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        assets,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        width: size,
      ),
    );
  }
}
