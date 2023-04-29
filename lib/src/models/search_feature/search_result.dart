import 'package:equatable/equatable.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_page.dart';

class SearchResult extends Equatable {
  const SearchResult({required this.results});

  factory SearchResult.fromJson(Map<dynamic, dynamic> json) {
    return SearchResult(
      results: json['pages'] != null
          ? List<SearchPage>.from(
              json['pages'].map((item) => SearchPage.fromJson(item)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> inputBody = {};
    inputBody['pages'] =
        results.map((searchPage) => searchPage.toJson()).toList();
    return inputBody;
  }

  final List<SearchPage> results;

  @override
  List<Object?> get props => [results];
}
