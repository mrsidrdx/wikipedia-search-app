import 'package:wikipedia_search_app/src/models/search_feature/search_query.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';

abstract class AbstractSearchRepository {
  Future<SearchResult> fetchSearchResults(SearchQuery searchQuery);
}
