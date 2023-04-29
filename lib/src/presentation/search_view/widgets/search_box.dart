import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikipedia_search_app/src/logic/search/search_bloc.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_query.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  final FocusNode _searchFocusNode = FocusNode();
  List<String>? _searchHistory;
  bool _isSearchFocused = false;

  void _searchWiki(String query) {
    FocusScope.of(context).requestFocus(FocusNode());
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) {
      return;
    }
    SearchQuery searchQuery = SearchQuery(query: trimmedQuery);
    context.read<SearchBloc>().add(Query(searchQuery));
  }

  void _fetchHistory(String? query) {
    context.read<SearchBloc>().add(FetchHistory(query));
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
      if (_isSearchFocused && _searchHistory == null) {
        _fetchHistory(null);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Type your query...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: _searchWiki,
                  onChanged: _fetchHistory,
                  focusNode: _searchFocusNode,
                ),
                BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) {
                    if (state is FetchHistoryFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)));
                    } else if (state is FetchHistorySuccess) {
                      _searchHistory = state.queries;
                    }
                  },
                  builder: (context, state) {
                    if (state is FetchHistoryLoading) {
                      return const Center(child: LinearProgressIndicator());
                    }
                    return _isSearchFocused &&
                            _searchHistory != null &&
                            _searchHistory!.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            // margin: const EdgeInsets.symmetric(
                            //     vertical: 4, horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _searchHistory!
                                  .map((history) => GestureDetector(
                                        onTap: () {
                                          _searchController.text = history;
                                          _searchWiki(history);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            history,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  _searchWiki(_searchController.text);
                },
                child: const Text('Search'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
