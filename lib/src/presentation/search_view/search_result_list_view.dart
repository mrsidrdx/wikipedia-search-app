import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wikipedia_search_app/src/commons/utils.dart';
import 'package:wikipedia_search_app/src/logic/search/search_bloc.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikipedia_search_app/src/presentation/search_view/widgets/search_box.dart';
import 'package:wikipedia_search_app/src/presentation/search_view/widgets/search_loading_shimmer.dart';
import 'package:wikipedia_search_app/src/presentation/search_view/widgets/search_result_list.dart';
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
  SearchResult? _searchResults;

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
            const SearchBox(),
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
                  return const SearchLoadingShimmerView();
                } else if (state is SearchNotFound) {
                  return const Center(child: Text('No results found'));
                }
                return _searchResults != null
                    ? SearchResultList(searchResults: _searchResults!)
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
