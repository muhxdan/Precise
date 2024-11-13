import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/core/utils/constants.dart';
import 'package:precise/domain/entities/theme.dart' as entity;
import 'package:precise/presentation/blocs/settings/settings_bloc.dart';
import 'package:precise/presentation/widgets/app_bar_back_button.dart';

class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        title: const Text(Constants.themesPage),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsBloc>().add(GetThemeEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SettingsLoaded) {
            return ListView(
              children: entity.ThemeSetting.values.map((setting) {
                return ListTile(
                  title: Text(setting.name.toUpperCase()),
                  leading: Radio<entity.ThemeSetting>(
                    value: setting,
                    groupValue: state.theme.setting,
                    onChanged: (entity.ThemeSetting? value) {
                      if (value != null) {
                        context.read<SettingsBloc>().add(
                              ChangeThemeEvent(entity.Theme(value)),
                            );
                      }
                    },
                  ),
                );
              }).toList(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
