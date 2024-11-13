import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:precise/core/utils/assets.dart';

class EmptyContainer extends StatelessWidget {
  final String text;
  const EmptyContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetVectors.ilEmpty,
            width: 80,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
