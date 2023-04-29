import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';

class WikipediaSearchCache {
  factory WikipediaSearchCache() => _searchCache;

  WikipediaSearchCache._internal();

  static Future<void> init() async {
    _searchCache._prefs ??= await SharedPreferences.getInstance();
    _searchCache._cachedQueries =
        _searchCache._prefs!.getStringList(_cachedQueriesKey) ?? [];
    _searchCache._cachedResults =
        json.decode(_searchCache._prefs!.getString(_cachedResultsKey) ?? '{}');
  }

  static SearchResult? get(String query) {
    // if query exists in _cachedQueries then retrieve result from _cachedResults, and convert result to SearchResult object
    // if query does not exist then return null
    if (_searchCache._cachedQueries!.contains(query)) {
      final resultJson = _searchCache._cachedResults![query];
      return SearchResult.fromJson(resultJson);
    } else {
      return null;
    }
  }

  static void put(String query, Map<dynamic, dynamic> result) {
    // if query does not exist add query and result to _cachedQueries and _cachedResults
    // if query does not exist, and _cachedQueries.length == _maxCacheSize, then remove first added query in _cachedQueries and _cachedResults and then add
    // if query exists do nothing
    if (!_searchCache._cachedQueries!.contains(query)) {
      if (_searchCache._cachedQueries!.length == _maxCacheSize) {
        final firstQuery = _searchCache._cachedQueries!.removeAt(0);
        _searchCache._cachedResults!.remove(firstQuery);
      }
      _searchCache._cachedQueries!.add(query);
      _searchCache._cachedResults![query] = result;
      _saveCache();
    }
  }

  static void _saveCache() {
    _searchCache._prefs!
        .setStringList(_cachedQueriesKey, _searchCache._cachedQueries!);
    _searchCache._prefs!
        .setString(_cachedResultsKey, json.encode(_searchCache._cachedResults));
  }

  static List<String> get queryHistory {
    return _searchCache._cachedQueries ?? [];
  }

  List<String>? _cachedQueries;
  Map<dynamic, dynamic>? _cachedResults;
  static const int _maxCacheSize = 5;
  static const String _cachedQueriesKey = 'cachedQueries';
  static const String _cachedResultsKey = 'cachedResults';
  SharedPreferences? _prefs;

  static final WikipediaSearchCache _searchCache =
      WikipediaSearchCache._internal();
}
