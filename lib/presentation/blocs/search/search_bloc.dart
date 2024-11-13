import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:precise/domain/entities/article.dart';
import 'package:precise/domain/usecases/search_articles.dart';

part 'search_event.dart';
part 'search_state.dart';

// class SearchBloc extends Bloc<SearchEvent, SearchState> {
//   final SearchArticlesUseCase searchArticlesUseCase;
//   static const int _pageSize = 10;

//   SearchBloc({
//     required this.searchArticlesUseCase,
//   }) : super(const SearchState()) {
//     on<SearchArticles>(_onSearchArticles);
//     on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
//     on<UpdateSearchArticleBookmark>(_onUpdateArticleBookmark);
//   }

//   Future<void> _onSearchArticles(
//     SearchArticles event,
//     Emitter<SearchState> emit,
//   ) async {
//     // Reset state for new search
//     emit(state.copyWith(
//       isLoading: true,
//       error: null,
//       articles: [],
//       currentPage: 1,
//       hasReachedMax: false,
//       keyword: event.keyword,
//     ));

//     final result = await searchArticlesUseCase(
//       SearchParams(
//         keyword: event.keyword,
//         page: 1,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         isLoading: false,
//         error: failure.message,
//       )),
//       (articles) => emit(state.copyWith(
//         articles: articles,
//         isLoading: false,
//         hasReachedMax: articles.length < _pageSize,
//       )),
//     );
//   }

//   Future<void> _onLoadMoreSearchResults(
//     LoadMoreSearchResults event,
//     Emitter<SearchState> emit,
//   ) async {
//     if (!state.canLoadMore) return;

//     emit(state.copyWith(isLoadingMore: true));

//     final nextPage = state.currentPage + 1;
//     final result = await searchArticlesUseCase(
//       SearchParams(
//         keyword: state.keyword!,
//         page: nextPage,
//       ),
//     );

//     result.fold(
//       (failure) => emit(state.copyWith(
//         isLoadingMore: false,
//         error: failure.message,
//       )),
//       (newArticles) {
//         final allArticles = [...state.articles, ...newArticles];
//         emit(state.copyWith(
//           articles: allArticles,
//           currentPage: nextPage,
//           isLoadingMore: false,
//           hasReachedMax: newArticles.length < _pageSize,
//         ));
//       },
//     );
//   }

//   void _onUpdateArticleBookmark(
//     UpdateSearchArticleBookmark event,
//     Emitter<SearchState> emit,
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

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchArticlesUseCase useCase;

  SearchBloc(this.useCase) : super(const SearchState()) {
    on<SearchArticles>(_onSearchArticles);
    on<LoadMoreArticles>(_onLoadMoreArticles);
    on<ClearSearch>(_onClearSearch); // Event untuk menghapus hasil pencarian
  }

  Future<void> _onSearchArticles(
      SearchArticles event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        isLoading: false,
        articles: [],
        errorMessage: null,
        hasMore: false,
        isInitial: true,
      ));
      return;
    }

    emit(state.copyWith(
        isLoading: true, errorMessage: null, articles: [], isInitial: false));

    final result = await useCase(SearchParams(keyword: event.query, page: 1));

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (articles) => emit(state.copyWith(
        isLoading: false,
        articles: articles,
        hasMore: articles.length == 10,
        isInitial: false,
      )),
    );
  }

  Future<void> _onLoadMoreArticles(
      LoadMoreArticles event, Emitter<SearchState> emit) async {
    if (state.isPaginating || !state.hasMore) return;

    emit(state.copyWith(isPaginating: true));

    final result = await useCase(SearchParams(
      keyword: event.query,
      page: (state.articles.length ~/ 10) + 1,
    ));

    result.fold(
      (failure) => emit(
          state.copyWith(isPaginating: false, errorMessage: failure.message)),
      (newArticles) => emit(state.copyWith(
        isPaginating: false,
        articles: List.of(state.articles)..addAll(newArticles),
        hasMore: newArticles.length == 10,
      )),
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(
      isLoading: false,
      articles: [],
      errorMessage: null,
      hasMore: false,
      isInitial: true,
    ));
  }
}
