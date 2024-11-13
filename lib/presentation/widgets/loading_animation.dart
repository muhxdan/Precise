import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:precise/core/utils/assets.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.repeat(); // Repeat the animation
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OverflowBox(
        minHeight: 100,
        maxHeight: 100,
        child: Lottie.asset(
          AssetsLottie.loading,
          controller: _animationController,
          animate: true,
          onLoaded: (composition) {
            _animationController
              ..duration = composition.duration
              ..repeat();
          },
        ),
      ),
    );
  }
}
