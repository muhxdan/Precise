import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/usecases/get_articles.dart';
import 'package:precise/domain/usecases/search_articles.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
  final GetArticlesUseCase getArticlesUseCase;
  final SearchArticlesUseCase searchArticlesUseCase;

  ArticlesBloc({
    required this.getArticlesUseCase,
    required this.searchArticlesUseCase,
  }) : super(const ArticlesState()) {
    on<GetArticlesEvent>(_onGetArticles);
    // on<SearchArticlesEvent>(_onSearchArticles);
    on<UpdateArticleBookmarkEvent>(_onUpdateArticleBookmark);
  }

  Future<void> _onGetArticles(
    GetArticlesEvent event,
    Emitter<ArticlesState> emit,
  ) async {
    if (event.loadMore) {
      // Prevent multiple load more requests
      if (!state.canLoadMore) return;

      emit(state.copyWith(isLoadingMore: true));

      // Artificial delay for loading indicator
      await Future.delayed(const Duration(seconds: 1));

      final result = await getArticlesUseCase(
        GetArticlesParams(
          category: event.category,
          page: state.currentPage + 1,
          shouldCache: false,
          forceRefresh: event.forceRefresh ?? false,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          error: failure.message,
          isLoadingMore: false,
        )),
        (articles) {
          if (articles.isEmpty) {
            emit(state.copyWith(
              hasReachedMax: true,
              isLoadingMore: false,
            ));
          } else {
            emit(state.copyWith(
              articles: [...state.articles, ...articles],
              currentPage: state.currentPage + 1,
              isLoadingMore: false,
            ));
          }
        },
      );
    } else {
      // Initial or refresh load
      emit(state.copyWith(
        isLoading: true,
        error: null, // Clear any previous errors
      ));

      final result = await getArticlesUseCase(
        GetArticlesParams(
          category: event.category,
          page: 1,
          shouldCache: true,
          forceRefresh: event.forceRefresh ?? false,
        ),
      );

      result.fold(
        (failure) => emit(state.copyWith(
          error: failure.message,
          isLoading: false,
        )),
        (articles) => emit(state.copyWith(
          articles: articles,
          currentPage: 1,
          isLoading: false,
          hasReachedMax: false,
          error: null,
        )),
      );
    }
  }

  // Future<void> _onSearchArticles(
  //   SearchArticlesEvent event,
  //   Emitter<ArticlesState> emit,
  // ) async {
  //   emit(state.copyWith(
  //     isLoading: true,
  //     error: null,
  //     keyword: event.keyword,
  //   ));

  //   final result = await searchArticlesUseCase(
  //     SearchArticlesParams(keyword: event.keyword),
  //   );

  //   result.fold(
  //     (failure) => emit(state.copyWith(
  //       error: failure.message,
  //       isLoading: false,
  //     )),
  //     (articles) => emit(state.copyWith(
  //       articles: articles,
  //       isLoading: false,
  //       currentPage: 1,
  //       hasReachedMax: true, // Usually search doesn't have pagination
  //     )),
  //   );
  // }

  void _onUpdateArticleBookmark(
    UpdateArticleBookmarkEvent event,
    Emitter<ArticlesState> emit,
  ) {
    final updatedArticles = state.articles.map((article) {
      if (article.id == event.article.id) {
        return event.article;
      }
      return article;
    }).toList();

    emit(state.copyWith(articles: updatedArticles));
  }
}

// class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {
//   final GetArticlesUseCase getArticlesUseCase;
//   final SearchArticlesUseCase searchArticlesUseCase;

//   ArticlesBloc({
//     required this.getArticlesUseCase,
//     required this.searchArticlesUseCase,
//   }) : super(ArticlesInitial()) {
//     on<GetArticlesEvent>(_onGetArticles);
//     on<SearchArticlesEvent>(_onSearchArticles);
//     on<UpdateArticleBookmarkEvent>(_onUpdateArticleBookmark);
//   }

//   Future<void> _onGetArticles(
//     GetArticlesEvent event,
//     Emitter<ArticlesState> emit,
//   ) async {
//     if (event.loadMore) {
//       if (state.isLoadingMore || state.hasReachedMax) return;
//       emit(state.copyWith(isLoadingMore: true));

//       // Artificial delay for loading indicator
//       await Future.delayed(const Duration(seconds: 1));

//       final result = await getArticlesUseCase(
//         GetArticlesParams(
//             category: event.category,
//             page: state.currentPage + 1,
//             shouldCache: false,
//             forceRefresh: event.forceRefresh ?? false),
//       );

//       result.fold(
//         (failure) => emit(state.copyWith(
//           error: failure.message,
//           isLoadingMore: false,
//         )),
//         (articles) {
//           if (articles.isEmpty) {
//             emit(state.copyWith(
//               hasReachedMax: true,
//               isLoadingMore: false,
//             ));
//           } else {
//             emit(state.copyWith(
//               articles: [...state.articles, ...articles],
//               currentPage: state.currentPage + 1,
//               isLoadingMore: false,
//             ));
//           }
//         },
//       );
//     } else {
//       emit(state.copyWith(isLoading: true));

//       final result = await getArticlesUseCase(
//         GetArticlesParams(
//             category: event.category,
//             page: 1,
//             shouldCache: true,
//             forceRefresh: event.forceRefresh ?? false),
//       );

//       result.fold(
//         (failure) => emit(state.copyWith(
//           error: failure.message,
//           isLoading: false,
//         )),
//         (articles) => emit(state.copyWith(
//           articles: articles,
//           currentPage: 1,
//           isLoading: false,
//           hasReachedMax: false,
//         )),
//       );
//     }
//   }

//   Future<void> _onSearchArticles(
//     SearchArticlesEvent event,
//     Emitter<ArticlesState> emit,
//   ) async {
//     emit(ArticlesLoading());

//     final result = await searchArticlesUseCase(
//       SearchArticlesParams(keyword: event.keyword),
//     );

//     result.fold(
//       (failure) => emit(ArticlesError(failure.message)),
//       (articles) => emit(ArticlesLoaded(articles)),
//     );
//   }

//   void _onUpdateArticleBookmark(
//     UpdateArticleBookmarkEvent event,
//     Emitter<ArticlesState> emit,
//   ) {
//     final updatedArticles = state.articles.map((article) {
//       if (article.id == event.article.id) {
//         return event.article;
//       }
//       return article;
//     }).toList();

//     emit(state.copyWith(articles: updatedArticles));
//   }
// }
