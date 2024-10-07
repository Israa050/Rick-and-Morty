part of 'characters_cubit.dart';


@immutable
sealed class CharactersState {}

final class CharactersInitial extends CharactersState {}

class CharactersLoaded extends CharactersState{
  final List<Character> characters;

  CharactersLoaded({required this.characters});


}

class QuoteLoaded extends CharactersState{
  final List<Quote> quotes;

  QuoteLoaded({required this.quotes});
}

class CharacterLoading extends CharactersState{
  final List<Character> oldCharacters;
  final bool isFirstFetch;

  CharacterLoading({required this.oldCharacters, this.isFirstFetch = false});
}

// class EpisodesLoaded extends CharactersState{
//   final List<String> episodes;

//   EpisodesLoaded({required this.episodes});
// }