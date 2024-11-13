import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/utils/assets.dart';
import 'package:precise/core/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView.builder(
          itemCount: Constants.settings.length,
          itemBuilder: (context, index) {
            final setting = Constants.settings[index];
            return ListTile(
              title: Text(setting["title"]!),
              subtitle: Text(setting["subtitle"]!),
              leading: SvgPicture.asset(setting["leading"]!),
              trailing: SvgPicture.asset(AssetVectors.icArrowRight),
              onTap: () => context.push(setting["route"]!),
            );
          },
        ));
  }
}
