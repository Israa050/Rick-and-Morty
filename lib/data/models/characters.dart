

class Character{
  late int id;
  late String name;
  late String status;
  late String species;
  late String gender;
  late String image;
  late String url;
  late String type;
  late Location location;
  late Origin origin;
  late List<dynamic> episodes;

  Character.fromJson(Map<String,dynamic> json){
    id = json['id'];
    name = json['name'];
    status = json['status'];
    species = json['species'];
    gender = json['gender'];
    image = json['image'];
    url = json['url'];
    type = json['type'];
    location = Location.fromJson(json['location']);
    origin = Origin.fromJson(json['origin']);
    episodes = json['episode'];
  }

  
}

class Location{
  late String name;

  Location.fromJson(Map<String,dynamic> json){
    name = json['name'];
  }
}

class Origin{
  late String name;

  Origin.fromJson(Map<String,dynamic>json){
    name = json['name'];
  }
}

class Info{
  late int count;
  late int pages;
  String? next;
  String? prev;


  Info.fromJson(Map<String,dynamic> json){
    count = json['count'];
    pages = json['pages'];
    next = json['next'];
    prev = json['prev'];
  }
  
}

class Episode{
  late String episode;

  Episode.fromJson(Map<String,dynamic>json){
    episode = json['episode'];
  }

}