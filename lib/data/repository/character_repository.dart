
import 'package:rick/data/models/characters.dart';
import 'package:rick/data/models/quote.dart';
import 'package:rick/data/web_services/characters_web_services.dart';

class CharactersRepository{

  final CharacterWebServices characterWebServices;

  CharactersRepository({required this.characterWebServices});

   Future<List<Character>> getAllCharacters()async{
    final character = await characterWebServices.getAllCharacters();
    // List<Character> list = character.map((character) => Character.fromJson(character)).toList();
    // print("########################################################");
    // print(list[0].name);
    return character.map((character) => Character.fromJson(character)).toList();
  }

  
  Future<List<Quote>> getRandomQuote() async {
    final quote = await characterWebServices.getRandomQuote();
    return quote.map((value) => Quote.fromJson(value)).toList();
  }

  Future<List<Character>> fetchCharacters(int page)async {
    final character = await characterWebServices.fetchCharacters(page);
    return character.map((character) => Character.fromJson(character)).toList();
  }

  // Future<void> getSingleEpisode(List<String> urls) async {
  //   List<dynamic> episodes = [];
  //  for(int i =0; i<urls.length-1; i++){
  //    var value = await characterWebServices.getSingleEpisode(urls[i]);
  //     episodes.add(value);
  //   }
  //   print('List Of Episodes');
  //   print(episodes);
  //  // return episodes;
  // }

}