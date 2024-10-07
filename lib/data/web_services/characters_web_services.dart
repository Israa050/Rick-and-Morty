
import 'package:dio/dio.dart';
import 'package:rick/utils/consonants.dart';

class CharacterWebServices {
  late Dio dio;

  CharacterWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseURL,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20), //60seconds,
      receiveTimeout: const Duration(seconds: 20),
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      // Response response = await dio.get("character",queryParameters: {'page':2});
      Response response = await dio.get("character");
      print(response.data['results'].toString());
      return response.data['results'];
    } catch (e) {
      print("API Error: ${e.toString()}");
    }
    return [];
  }

  Future<List<dynamic>> getRandomQuote() async {
    try {
      BaseOptions options = BaseOptions(
        baseUrl: quotesUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20), //60seconds,
        receiveTimeout: const Duration(seconds: 20),
      );
      Dio dio2 = Dio(options);
      Response response = await dio2.get('quotes/5');
      print("###         Quote is:");
      print(response.data);
      return response.data;
    } catch (e) {
      print("Quote API Error ${e.toString()}");
    }
    return [];
  }

  Future<List<dynamic>> fetchCharacters(int page)async {
     try{
       BaseOptions options = BaseOptions(
        baseUrl: baseURL,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20), //60seconds,
        receiveTimeout: const Duration(seconds: 20),
      );
      Dio dio2 = Dio(options);

      Response response = await dio2.get('character',queryParameters: {'page': page});
      print(response.data['results']);
      return response.data['results'];
     }catch(e){
      print("Fetch Data Error: ${e.toString()}");
     }
     return [];
  }

  // Future<String> getSingleEpisode(String url)async{
  //   try{
  //   //  BaseOptions options = BaseOptions(
  //   //     baseUrl: 'https://rickandmortyapi.com/api/episode/1',
  //   //     receiveDataWhenStatusError: true,
  //   //     connectTimeout: const Duration(seconds: 20), //60seconds,
  //   //     receiveTimeout: const Duration(seconds: 20),
  //   //   );
  //   Dio dio3 = Dio();

  //   Response response = await dio.getUri(Uri.parse(url));

  //   print ("episodes result =&&&&&&&& ");
  //   print(response.data['episode']);

  //   return response.data['name'];

  //   }catch(e){
  //     print("fetch Episode error: ${e.toString()}");
  //   }
  //   return '';
  // }

  

  
  
}
