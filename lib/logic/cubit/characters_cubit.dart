import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/models/quote.dart';
import 'package:rick/data/repository/character_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {

  final CharactersRepository charactersRepository;
 List<Character>? characters;

 int page = 1;



  CharactersCubit({required this.charactersRepository}) : super(CharactersInitial());

  List<Character> getAllCharacters(){
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters: characters));
      this.characters = characters;
    });
    return characters?? [];
  }

  void getRandomQuotes(){
    charactersRepository.getRandomQuote().then((quotes) {
      emit(QuoteLoaded(quotes: quotes));
    } );
  }

  void getCharacters() {
    if(state is CharacterLoading) return;

    final currentState = state;
    List<Character> oldCharacters = [];

    if(currentState is CharactersLoaded){
      oldCharacters = currentState.characters;
    }

    emit(CharacterLoading(oldCharacters: oldCharacters,isFirstFetch: page==1));
     if(page == 42) return;
    charactersRepository.fetchCharacters(page).then((newCharacters){
      page++;
      final characters = (state as CharacterLoading).oldCharacters;
      characters.addAll(newCharacters);
      emit(CharactersLoaded(characters: characters));
    });

  }

  // void getAllEpisodes(List<String> list){
  //   charactersRepository.getSingleEpisode(list).then((episode){
  //     emit(EpisodesLoaded(episodes: episode));
  //   });
  // }
  
}
