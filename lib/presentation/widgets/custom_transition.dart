import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomTransition extends CustomTransitionPage {
  CustomTransition({
    required super.child,
    required LocalKey super.key,
    required String super.name,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final primarySlideAnimation = animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            );

            final secondarySlideAnimation = secondaryAnimation.drive(
              Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1.0, 0.0),
              ).chain(CurveTween(curve: Curves.easeInOut)),
            );

            return SlideTransition(
              position: primarySlideAnimation,
              child: SlideTransition(
                position: secondarySlideAnimation,
                child: child,
              ),
            );
          },
        );
}
