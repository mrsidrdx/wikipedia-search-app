import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_query.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';
import 'package:wikipedia_search_app/src/repository/search_repository/abstract_search_repository.dart';

import '../../repository/search_repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.searchRepository) : super(SearchInitial()) {
    on<Query>(_onQuery);
  }

  Future<void> _onQuery(Query event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      SearchResult response =
          await searchRepository.fetchSearchResults(event.searchQuery);
      emit(SearchSuccess(response));
    } on SearchQueryException catch (e) {
      if (e.errorMessage == 'No results found') {
        emit(SearchNotFound());
        return;
      }
      emit(SearchFailure(e.errorMessage));
    } catch (e) {
      emit(SearchFailure(e.toString()));
    }
  }

  final AbstractSearchRepository searchRepository;
}
