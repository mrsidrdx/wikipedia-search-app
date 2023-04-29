part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Query extends SearchEvent {
  const Query(this.searchQuery);
  final SearchQuery searchQuery;
}

class FetchHistory extends SearchEvent {
  const FetchHistory(this.query);
  final String? query;
}
