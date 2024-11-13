import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:precise/core/network/api_client.dart';
import 'package:precise/core/network/network_info.dart';
import 'package:precise/core/utils/logger.dart';
import 'package:precise/data/datasources/local/article_local_datasource.dart';
import 'package:precise/data/datasources/local/settings_local_datasource.dart';
import 'package:precise/data/datasources/remote/article_remote_datasource.dart';
import 'package:precise/data/models/article_model.dart';
import 'package:precise/data/repositories/article_repository_impl.dart';
import 'package:precise/data/repositories/settings_repository_impl.dart';
import 'package:precise/domain/repositories/article_repository.dart';
import 'package:precise/domain/repositories/settings_repository.dart';
import 'package:precise/domain/usecases/get_articles.dart';
import 'package:precise/domain/usecases/get_bookmarked_articles.dart';
import 'package:precise/domain/usecases/search_articles.dart';
import 'package:precise/domain/usecases/settings/get_theme.dart';
import 'package:precise/domain/usecases/settings/set_theme.dart';
import 'package:precise/domain/usecases/toggle_bookmark.dart';
import 'package:precise/presentation/blocs/article/article_bloc.dart';
import 'package:precise/presentation/blocs/bookmark/bookmark_bloc.dart';
import 'package:precise/presentation/blocs/search/search_bloc.dart';
import 'package:precise/presentation/blocs/settings/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  try {
    // First, initialize Hive
    await Hive.initFlutter();

    // Register shared preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton(() => sharedPreferences);

    // Clear any existing adapters to prevent conflicts
    if (!Hive.isAdapterRegistered(0)) {
      // 0 is the typeId for ArticleModel
      Hive.registerAdapter(ArticleModelAdapter());
    }

    // Before opening boxes, make sure any existing boxes are closed
    await Hive.close();

    // try {
    //   // Open Hive boxes with explicit type parameters
    final articlesBox = await Hive.openBox<ArticleModel>('articles',
        compactionStrategy: (entries, deletedEntries) {
      return deletedEntries > 50;
    });

    final cacheBox = await Hive.openBox('cache_metadata');
    final bookmarkBox = await Hive.openBox<bool>('bookmarks');

    // Register core dependencies
    getIt.registerLazySingleton(() => Dio());
    getIt.registerLazySingleton(() => AppLogger.logger);
    getIt.registerLazySingleton(() => Connectivity());
    getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

    // Register ApiClient
    getIt.registerLazySingleton<ApiClient>(
      () => ApiClient(dio: getIt()),
    );

    // Register Hive boxes
    getIt.registerSingleton<Box<ArticleModel>>(articlesBox);
    getIt.registerSingleton<Box<dynamic>>(cacheBox);
    getIt.registerSingleton<Box<bool>>(bookmarkBox);

    // Register data sources
    getIt.registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(client: getIt()),
    );
    getIt.registerLazySingleton<ArticleLocalDataSource>(
      () => ArticleLocalDataSourceImpl(
          articleBox: getIt(), cacheBox: getIt(), bookmarkBox: getIt()),
    );

    getIt.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sharedPreferences: getIt()),
    );

    // Register repository
    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );

    getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localDataSource: getIt()),
    );

    // Register use cases
    getIt.registerLazySingleton(() => GetArticlesUseCase(getIt()));
    getIt.registerLazySingleton(() => SearchArticlesUseCase(getIt()));
    getIt.registerLazySingleton(() => ToggleArticleBookmarkUseCase(getIt()));
    getIt.registerLazySingleton(() => GetBookmarkedArticlesUseCase(getIt()));

    getIt.registerLazySingleton(() => GetTheme(getIt()));
    getIt.registerLazySingleton(() => SetTheme(getIt()));

    // Register Blocs
    getIt.registerFactory(
      () => ArticlesBloc(
        searchArticlesUseCase: getIt(),
        getArticlesUseCase: getIt(),
      ),
    );

    getIt.registerFactory(
      () => BookmarksBloc(
        getBookmarkedArticlesUseCase: getIt(),
        toggleArticleBookmarkUseCase: getIt(),
      ),
    );

    getIt.registerFactory(
      () => SearchBloc(getIt()),
    );

    getIt.registerFactory(
      () => SettingsBloc(
        getTheme: getIt(),
        setTheme: getIt(),
      ),
    );
  } catch (e) {
    // If there's an error with the Hive box, try to delete and recreate it
    await Hive.deleteBoxFromDisk('articles');
    await Hive.deleteBoxFromDisk('cacheConfig');

    // Rethrow the error to handle it at the app level
    rethrow;
  }
}

// final GetIt getIt = GetIt.instance;

// Future<void> setupInjection() async {
//   // Initialize Hive and register adapters
//   await Hive.initFlutter();
//   Hive.registerAdapter(
//       ArticleModelAdapter()); // Register the ArticleModel adapter

//   // Open Hive boxes
//   final articlesBox = await Hive.openBox<ArticleModel>('articles');
//   final cacheConfigBox = await Hive.openBox('cacheConfig');

//   // Register core dependencies
//   getIt.registerLazySingleton(() => Dio());
//   getIt.registerLazySingleton(() => AppLogger.logger);
//   getIt.registerLazySingleton(() => Connectivity());
//   getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

//   // Register ApiClient with Dio and Logger dependencies
//   getIt.registerLazySingleton<ApiClient>(
//       () => ApiClient(dio: getIt(), logger: getIt()));

//   // Register Hive boxes
//   getIt.registerSingleton<Box<ArticleModel>>(articlesBox);
//   getIt.registerSingleton<Box>(cacheConfigBox);

//   // Register data sources
//   getIt.registerLazySingleton<ArticleRemoteDataSource>(
//     () => ArticleRemoteDataSourceImpl(apiClient: getIt()),
//   );
//   getIt.registerLazySingleton<ArticleLocalDataSource>(
//     () => ArticleLocalDataSourceImpl(
//       articlesBox: getIt(),
//       cacheConfigBox: getIt(),
//     ),
//   );

//   // Register repository
//   getIt.registerLazySingleton<ArticleRepository>(
//     () => ArticleRepositoryImpl(
//       remoteDataSource: getIt(),
//       localDataSource: getIt(),
//       maxCacheAge: const Duration(hours: 1),
//     ),
//   );

//   // Register use cases
//   getIt.registerLazySingleton(() => GetArticles(getIt()));
//   getIt.registerLazySingleton(() => SearchArticles(getIt()));
//   getIt.registerLazySingleton(() => ToggleBookmark(getIt()));
//   getIt.registerLazySingleton(() => GetBookmarkedArticles(getIt()));

//   // Register Blocs
//   getIt.registerFactory(() => ArticleBloc(getIt()));
//   getIt.registerFactory(() => SearchBloc(getIt()));
//   getIt.registerFactory(() => BookmarkBloc(getIt(), getIt()));
// }
