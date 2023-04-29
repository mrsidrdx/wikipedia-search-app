/// A placeholder class that represents an entity or model.
import 'package:equatable/equatable.dart';

class SearchQuery extends Equatable {
  const SearchQuery({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}
