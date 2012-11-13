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
  
  Map toJson(){
    return {
      'id': id,
      'color': color
    };
  }
}
