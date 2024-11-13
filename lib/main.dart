import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:precise/core/di/injection.dart';
import 'package:precise/core/routes/app_router.dart';
import 'package:precise/core/theme/app_theme.dart';
import 'package:precise/core/utils/constants.dart';
import 'package:precise/domain/entities/theme.dart';
import 'package:precise/presentation/blocs/article/article_bloc.dart';
import 'package:precise/presentation/blocs/bookmark/bookmark_bloc.dart';
import 'package:precise/presentation/blocs/search/search_bloc.dart';
import 'package:precise/presentation/blocs/settings/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupInjection();

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ArticlesBloc>()),
        BlocProvider(
            create: (_) =>
                getIt<BookmarksBloc>()..add(GetBookmarkedArticlesEvent())),
        BlocProvider(
            create: (_) => getIt<SettingsBloc>()..add(GetThemeEvent())),
        BlocProvider(create: (_) => getIt<SearchBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;

          if (state is SettingsLoaded) {
            switch (state.theme.setting) {
              case ThemeSetting.light:
                themeMode = ThemeMode.light;
                break;
              case ThemeSetting.dark:
                themeMode = ThemeMode.dark;
                break;
              default:
                themeMode = ThemeMode.system;
            }
          }
          return MaterialApp.router(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
