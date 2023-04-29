import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikipedia_search_app/src/commons/utils.dart';
import 'package:wikipedia_search_app/src/logic/search/search_bloc.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_page.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_query.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikipedia_search_app/src/services/settings/settings_controller.dart';

class SearchResultListView extends StatefulWidget {
  const SearchResultListView({Key? key, required this.settingsController})
      : super(key: key);

  static const routeName = '/';
  final SettingsController settingsController;

  @override
  State<SearchResultListView> createState() => _SearchResultListViewState();
}

class _SearchResultListViewState extends State<SearchResultListView> {
  final TextEditingController _searchController =
      TextEditingController(text: '');

  SearchResult? _searchResults;

  void _searchWiki(String query) async {
    final trimmedQuery = query.trim().toLowerCase();
    if (trimmedQuery.isEmpty) {
      return;
    }
    SearchQuery searchQuery = SearchQuery(query: trimmedQuery);
    context.read<SearchBloc>().add(Query(searchQuery));
  }

  Future<void> _launchUrl(int pageId) async {
    final Uri _url = Uri.parse('https://en.wikipedia.org/?curid=$pageId');
    if (!await launchUrl(_url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        checkIsDarkMode(context, widget.settingsController.themeMode);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipdia Search'),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
            ),
            onPressed: () {
              ThemeMode newThemeMode =
                  isDarkMode ? ThemeMode.light : ThemeMode.dark;
              widget.settingsController.updateThemeMode(newThemeMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: _searchResults == null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SvgPicture.asset(
                    'assets/images/search.svg',
                    width: 240,
                    height: 240,
                  ),
                )),
            Padding(
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
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Type your query...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: _searchWiki,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () => _searchWiki(_searchController.text),
                        child: const Text('Search'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)));
                } else if (state is SearchSuccess) {
                  _searchResults = state.result;
                  setState(() {});
                }
              },
              builder: (context, state) {
                if (state is SearchLoading) {
                  return searchLoadingShimmerView(context, isDarkMode);
                } else if (state is SearchNotFound) {
                  return const Center(child: Text('No results found'));
                }
                return _searchResults != null
                    ? searchResultListView(context, isDarkMode)
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget searchResultListView(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _searchResults!.results.length,
        itemBuilder: (BuildContext context, int index) {
          SearchPage page = _searchResults!.results[index];
          return searchResultTile(page, context, isDarkMode);
        },
      ),
    );
  }

  Padding searchResultTile(
      SearchPage page, BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          _launchUrl(page.pageId);
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              page.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(page.truncatedDescription),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                page.thumbnail,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
