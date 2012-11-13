part of gitonialib;

class Board {
  Player owner;
  List<Player> players;
  String id;
  
  Board(this.owner,this.players){
    id = new Uuid().v4();
  }
  
  Board.fromMap(Map data,this.players){
    id = data['id'];
    owner = null;
    for(var p in players){
      if(p.id==data['owner']){
        owner = p;         
      }
    }
  }
  
  Map toMap(){
    return {
      'id': id,
      'owner': owner!=null?owner.id:null
    };
  }
  
  Map toJson(){
    return toMap();
  }
}
