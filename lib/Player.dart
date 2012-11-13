part of gamelib;

class Player {
  String id;
  String name;
  int color;
  int cash;
 
  Player(this.color,this.name){
    id = new Uuid().v4();
    cash = 0;
  }
  
  Player.fromMap(Map data){
    id = data['id'];
    color = data['color'];
    cash = data['cash'];
    name = data['name'];
  }
  
  Map toMap(){
    return {
      'id': id,
      'color': color,
      'cash': cash,
      'name': name,
    };
  }
  
  Map toJson(){
    return toMap();
  }
}
