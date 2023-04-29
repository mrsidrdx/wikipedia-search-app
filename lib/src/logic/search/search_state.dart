part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

// States for searching query
class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  const SearchSuccess(this.result);
  final SearchResult result;
}

class SearchFailure extends SearchState {
  const SearchFailure(this.errorMessage);
  final String errorMessage;
}

class SearchNotFound extends SearchState {}

// States for fetching history queries
class FetchHistoryLoading extends SearchState {}

class FetchHistorySuccess extends SearchState {
  const FetchHistorySuccess(this.queries);
  final List<String> queries;
}

class FetchHistoryFailure extends SearchState {
  const FetchHistoryFailure(this.errorMessage);
  final String errorMessage;
}
