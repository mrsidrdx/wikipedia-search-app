import 'package:dio/dio.dart';
import 'package:wikipedia_search_app/src/services/cache_service.dart';

import '../../models/search_feature/search_query.dart';
import '../../models/search_feature/search_result.dart';
import '../../services/dio_service.dart';
import 'abstract_search_repository.dart';

class SearchQueryException implements Exception {
  SearchQueryException(this.errorMessage);

  final String errorMessage;
}

class FetchHistoryException implements Exception {
  FetchHistoryException(this.errorMessage);

  final String errorMessage;
}

class SearchRepository extends AbstractSearchRepository {
  SearchRepository(this._dioService);

  final DioService _dioService;

  @override
  Future<SearchResult> fetchSearchResults(SearchQuery searchQuery) async {
    try {
      final SearchResult? result = WikipediaSearchCache.get(searchQuery.query);
      if (result != null) {
        return result;
      }
      Response response = await _dioService.dioService.request(
          _dioService.wikipediaApi,
          options: Options(method: 'GET'),
          queryParameters: {
            'action': 'query',
            'format': 'json',
            'prop': 'pageimages|pageterms',
            'generator': 'prefixsearch',
            'redirects': 1,
            'formatversion': 2,
            'piprop': 'thumbnail',
            'pithumbsize': 50,
            'pilimit': 10,
            'wbptterms': 'description',
            'gpssearch': searchQuery.query,
            'gpslimit': 10
          });
      if (response.data['query'] == null) {
        throw SearchQueryException("No results found");
      }
      WikipediaSearchCache.put(searchQuery.query, response.data['query']);
      return SearchResult.fromJson(response.data['query']);
    } on SearchQueryException catch (e) {
      throw SearchQueryException(e.errorMessage);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        throw SearchQueryException("No internet connection");
      }
      if (e.response == null) {
        throw SearchQueryException("No internet connection");
      }
      throw SearchQueryException('Failed to fetch search results');
    } catch (e) {
      throw SearchQueryException('Failed to fetch search results');
    }
  }

  @override
  List<String> fetchQueryHistory({String? query}) {
    try {
      final List<String> history =
          WikipediaSearchCache.queryHistory.reversed.toList();
      if (query != null && query.isNotEmpty) {
        return history
            .where((keyword) => keyword.contains(query.trim().toLowerCase()))
            .toList();
      }
      return history;
    } on FetchHistoryException catch (e) {
      throw FetchHistoryException(e.errorMessage);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout) {
        throw FetchHistoryException("No internet connection");
      }
      if (e.response == null) {
        throw FetchHistoryException("No internet connection");
      }
      throw FetchHistoryException('Failed to fetch history');
    } catch (e) {
      throw FetchHistoryException('Failed to fetch history');
    }
  }
}
