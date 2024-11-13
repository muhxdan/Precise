// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:get_it/get_it.dart';
// import 'package:dio/dio.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:logger/logger.dart';
// import 'package:precise/core/network/api_client.dart';
// import 'package:precise/core/network/network_info.dart';
// import 'package:precise/core/utils/logger.dart';
// import 'package:precise/data/datasources/local/article_local_datasource.dart';
// import 'package:precise/data/datasources/news_local_datasource.dart';
// import 'package:precise/data/datasources/news_remote_datasource.dart';
// import 'package:precise/data/datasources/remote/article_remote_datasource.dart';
// import 'package:precise/data/models/article_model.dart';
// import 'package:precise/data/repositories/article_repository_impl.dart';
// import 'package:precise/data/repositories/news_repository_impl.dart';
// import 'package:precise/domain/repositories/news_repository.dart';
// import 'package:precise/domain/usecases/get_articles.dart';
// import 'package:precise/domain/usecases/get_articles_by_category.dart';
// import 'package:precise/domain/usecases/get_bookmarked_articles.dart';
// import 'package:precise/domain/usecases/toggle_bookmark.dart';
// import 'package:precise/presentation/blocs/article/bloc/article_bloc.dart';
// import 'package:precise/presentation/blocs/bookmark/bookmark_bloc.dart';
// import 'package:precise/presentation/blocs/news/news_bloc.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   // Initialize Hive
//   await Hive.initFlutter();
//   // Register ArticleModel adapter
//   Hive.registerAdapter(ArticleModelAdapter());

//   // Open Hive boxes
//   final articleBox = await Hive.openBox<ArticleModel>('articles');
//   final bookmarkBox = await Hive.openBox<ArticleModel>('bookmarks');

//   //! Features
//   // Blocs
//   sl.registerFactory(
//     () => ArticleListBloc(sl()),
//   );
//   sl.registerFactory(
//     () => BookmarkBloc(
//       getBookmarkedArticles: sl(),
//       toggleBookmark: sl(),
//     ),
//   );

//   // Use cases
//   sl.registerLazySingleton(() => GetArticles(sl()));
//   sl.registerLazySingleton(() => GetBookmarkedArticles(sl()));
//   sl.registerLazySingleton(() => ToggleArticleBookmark(sl()));

//   // Repository
//   sl.registerLazySingleton<ArticleRepository>(
//     () => ArticleRepositoryImpl(
//       remoteDataSource: sl(),
//       localDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );

//   // Data sources
//   sl.registerLazySingleton<ArticleRemoteDataSource>(
//     () => ArticleRemoteDataSourceImpl(sl()),
//   );

//   sl.registerLazySingleton<ArticleLocalDataSource>(
//     () => ArticleLocalDataSourceImpl(
//       articleBox: articleBox,
//       bookmarkBox: bookmarkBox,
//     ),
//   );

//   //! Core
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
//   sl.registerLazySingleton(() => ApiClient(dio: sl(), logger: sl()));

//   //! External
//   sl.registerLazySingleton(() => Dio());
//   sl.registerLazySingleton(() => Connectivity());
//   sl.registerLazySingleton(() => AppLogger.logger);
// }
