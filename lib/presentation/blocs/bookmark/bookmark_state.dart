part of 'bookmark_bloc.dart';

class BookmarksState extends Equatable {
  final List<Article> articles;
  final bool isLoading;
  final String? error;
  final Article? lastToggledArticle;

  const BookmarksState({
    this.articles = const [],
    this.isLoading = false,
    this.error,
    this.lastToggledArticle,
  });

  bool get hasError => error != null;
  bool get isEmpty => !isLoading && articles.isEmpty;

  BookmarksState copyWith({
    List<Article>? articles,
    bool? isLoading,
    String? error,
    Article? lastToggledArticle,
  }) {
    return BookmarksState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Pass null to clear error
      lastToggledArticle:
          lastToggledArticle, // Pass null to clear lastToggledArticle
    );
  }

  @override
  List<Object?> get props => [
        articles,
        isLoading,
        error,
        lastToggledArticle,
      ];
}


// abstract class BookmarksState extends Equatable {
//   const BookmarksState();

//   @override
//   List<Object?> get props => [];
// }

// class BookmarksInitial extends BookmarksState {}

// class BookmarksLoading extends BookmarksState {}

// class BookmarksLoaded extends BookmarksState {
//   final List<Article> bookmarkedArticles;

//   const BookmarksLoaded(this.bookmarkedArticles);

//   @override
//   List<Object> get props => [bookmarkedArticles];
// }

// class BookmarkToggled extends BookmarksState {
//   final Article article;

//   const BookmarkToggled(this.article);

//   @override
//   List<Object> get props => [article];
// }

// class BookmarksError extends BookmarksState {
//   final String message;

//   const BookmarksError(this.message);

//   @override
//   List<Object> get props => [message];
// }
