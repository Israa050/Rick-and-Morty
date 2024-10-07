
class Quote{
  late String author;
  late String quote;

  Quote.fromJson(Map<String,dynamic> json){
    author = json['author'];
    quote = json['quote'];
  }
}