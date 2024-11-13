import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/core/usecases/usecase.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/usecases/get_bookmarked_articles.dart';
import 'package:precise/domain/usecases/toggle_bookmark.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetBookmarkedArticlesUseCase getBookmarkedArticlesUseCase;
  final ToggleArticleBookmarkUseCase toggleArticleBookmarkUseCase;

  BookmarksBloc({
    required this.getBookmarkedArticlesUseCase,
    required this.toggleArticleBookmarkUseCase,
  }) : super(const BookmarksState()) {
    on<GetBookmarkedArticlesEvent>(_onGetBookmarkedArticles);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onGetBookmarkedArticles(
    GetBookmarkedArticlesEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getBookmarkedArticlesUseCase(NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (articles) => emit(state.copyWith(
        articles: articles,
        isLoading: false,
        error: null,
      )),
    );
  }

  Future<void> _onToggleBookmark(
    ToggleBookmarkEvent event,
    Emitter<BookmarksState> emit,
  ) async {
    final result = await toggleArticleBookmarkUseCase(
      ToggleBookmarkParams(article: event.article),
    );

    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (article) {
        emit(state.copyWith(lastToggledArticle: article));
        add(GetBookmarkedArticlesEvent()); // Refresh the bookmarks list
      },
    );
  }
}

// class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
//   final GetBookmarkedArticlesUseCase getBookmarkedArticlesUseCase;
//   final ToggleArticleBookmarkUseCase toggleArticleBookmarkUseCase;

//   BookmarksBloc({
//     required this.getBookmarkedArticlesUseCase,
//     required this.toggleArticleBookmarkUseCase,
//   }) : super(BookmarksInitial()) {
//     on<GetBookmarkedArticlesEvent>(_onGetBookmarkedArticles);
//     on<ToggleBookmarkEvent>(_onToggleBookmark);
//   }

//   Future<void> _onGetBookmarkedArticles(
//     GetBookmarkedArticlesEvent event,
//     Emitter<BookmarksState> emit,
//   ) async {
//     emit(BookmarksLoading());

//     final result = await getBookmarkedArticlesUseCase(NoParams());

//     result.fold(
//       (failure) => emit(BookmarksError(failure.message)),
//       (articles) {
//         emit(BookmarksLoaded(articles));
//       },
//     );
//   }

//   Future<void> _onToggleBookmark(
//     ToggleBookmarkEvent event,
//     Emitter<BookmarksState> emit,
//   ) async {
//     final result = await toggleArticleBookmarkUseCase(
//       ToggleBookmarkParams(article: event.article),
//     );

//     result.fold(
//       (failure) => emit(BookmarksError(failure.message)),
//       (article) {
//         emit(BookmarkToggled(article));
//         add(GetBookmarkedArticlesEvent());
//       },
//     );
//   }
// }
