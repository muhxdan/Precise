part of 'search_bloc.dart';

abstract class SearchEvent {}

class SearchArticles extends SearchEvent {
  final String query;

  SearchArticles(this.query);
}

class LoadMoreArticles extends SearchEvent {
  final String query;

  LoadMoreArticles(this.query);
}

class ClearSearch extends SearchEvent {}
