part of gamelib;

class Board {
  Player owner;
  List<Player> players;
  String id;
  
  Board(this.owner,this.players){
    id = new Uuid().v4();
  }
  
  Board.fromJson(Map data,this.players){
    id = data['id'];
    owner = null;
    for(var p in players){
      if(p.id==data['owner']){
        owner = p;         
      }
    }
  }
  
  Map toJson(){
    return {
      'id': id,
      'owner': owner!=null?owner.id:null
    };
  }
}