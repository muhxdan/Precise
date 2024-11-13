part of 'bookmark_bloc.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object> get props => [];
}

class GetBookmarkedArticlesEvent extends BookmarksEvent {}

class ToggleBookmarkEvent extends BookmarksEvent {
  final Article article;

  const ToggleBookmarkEvent(this.article);

  @override
  List<Object> get props => [article];
}
