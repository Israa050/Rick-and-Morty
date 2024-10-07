import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick/logic/cubit/characters_cubit.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/repository/character_repository.dart';
import 'package:rick/data/web_services/characters_web_services.dart';
import 'package:rick/presentation/screens/characters_screen.dart';
import 'package:rick/presentation/screens/character_datials_screen.dart';
import 'package:rick/utils/consonants.dart';

class AppRouter {
  static late CharactersRepository charactersRepository;
  static late CharactersCubit charactersCubit;

  AppRouter() {
    charactersRepository =
        CharactersRepository(characterWebServices: CharacterWebServices());
    charactersCubit =
        CharactersCubit(charactersRepository: charactersRepository);
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CharactersCubit>(
            create: (BuildContext context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );

      case charactersDetailsScreen:
        final Character character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => CharactersCubit(charactersRepository: charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
    return null;
  }
}
