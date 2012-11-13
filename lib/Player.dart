part of gamelib;

class Player {
  String id;
  int color;
 
  Player(this.color){
    id = new Uuid().v4();
  }
  
  Player.fromJson(Map data){
    id = data['id'];
    color = data['color'];
  }
  
  Map toMap(){
    return {
      'id': id,
      'color': color
    };
  }
  
  Map toJson(){
    return toMap();
  }
}
