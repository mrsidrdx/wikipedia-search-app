import 'package:equatable/equatable.dart';

class SearchPage extends Equatable {
  const SearchPage(
      {required this.pageId,
      required this.title,
      required this.description,
      required this.thumbnail});

  factory SearchPage.fromJson(Map<dynamic, dynamic> json) {
    return SearchPage(
        pageId: json['pageid'],
        title: json['title'],
        description:
            json['terms'] != null ? json['terms']['description'][0] : '',
        thumbnail: json['thumbnail'] != null
            ? json['thumbnail']['source']
            : 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png');
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> inputBody = {};
    inputBody['pageId'] = pageId;
    inputBody['title'] = title;
    inputBody['description'] = description;
    inputBody['thumbnail'] = thumbnail;
    return inputBody;
  }

  String get truncatedDescription {
    const int maxChars = 60;
    if (description.length <= maxChars) {
      return description;
    }
    return description.substring(0, maxChars) + '...';
  }

  final int pageId;
  final String title;
  final String description;
  final String thumbnail;

  @override
  List<Object?> get props => [pageId, title, description, thumbnail];
}
