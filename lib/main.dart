import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikipedia_search_app/src/logic/search/search_bloc.dart';
import 'package:wikipedia_search_app/src/repository/search_repository/abstract_search_repository.dart';
import 'package:wikipedia_search_app/src/repository/search_repository/search_repository.dart';
import 'package:wikipedia_search_app/src/services/cache_service.dart';
import 'package:wikipedia_search_app/src/services/dio_service.dart';
import 'package:wikipedia_search_app/src/services/settings/settings_controller.dart';
import 'package:wikipedia_search_app/src/services/settings/settings_service.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  WikipediaSearchCache.init();

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AbstractSearchRepository>(
          create: (context) => SearchRepository(DioService())),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                SearchBloc(context.read<AbstractSearchRepository>())),
      ],
      child: MyApp(settingsController: settingsController),
    ),
  ));
}
