import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/utils/assets.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: UnconstrainedBox(
        child: SvgPicture.asset(
          AssetVectors.icArrowLeft,
          width: 30,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
