import 'package:flutter/material.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';
import 'package:wikipedia_search_app/src/presentation/search_view/widgets/search_result_tile.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList(
      {Key? key, required this.searchResults, required this.isDarkMode})
      : super(key: key);

  final SearchResult searchResults;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: searchResults.results.length,
        itemBuilder: (BuildContext context, int index) {
          final page = searchResults.results[index];
          return SearchResultTile(page: page, isDarkMode: isDarkMode);
        },
      ),
    );
  }
}
