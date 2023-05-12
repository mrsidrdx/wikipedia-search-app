import 'package:flutter/material.dart';
import 'package:wikipedia_search_app/src/commons/utils.dart';
import 'package:wikipedia_search_app/src/models/search_feature/search_page.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({Key? key, required this.page}) : super(key: key);

  final SearchPage page;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          openWebPage(page.pageId);
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
