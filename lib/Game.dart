part of gamelib;

class Game {
  Board master;
  List<Board> forks;
  List<Player> players;
  int round;
  int roll;
  String id;
  List<int> tiles;
  
  Game(){
    forks = new List<Board>();
    players = new List<Player>();
    master = new Board(null,players);
    round = 0;
    roll = null;
    id = new Uuid().v4();
    
    tiles = new List<int>();
    var rand = new Random();
    for(var i=0;i<19;i++){
      tiles.add(rand.nextInt(6));
    }
  }
  
  Game.fromMap(Map data){
    // we must do the players first, because they are needed for boards
    players = new List<Player>();
    for(var d in data['players']){
      players.add(new Player.fromMap(d));
    }
    
    master = new Board.fromMap(data['master'],players);
    forks = new List<Board>();
    for(var d in data['forks']){
      forks.add(new Board.fromMap(d,players));
    }
    
    round = data['round'];
    roll = data['roll'];
    id = data['id'];
    tiles = data['tiles'];
  }
  
  Map toMap(){
    return {
      'master': master.toMap(),
      'forks': forks.map((fork) => fork.toMap()),
      'players': players.map((player) => player.toMap()),
      'round': round,
      'roll': roll,
      'id': id
    };
  }
  
  Map toJson(){
    return toMap();
  }
  
  
  String addPlayer(Player player){
    if(players.length == MAX_GAME_PLAYERS){
      return "Game is full";
    }
    for(var p in players){
      if(p.color == player.color){
        return "That color is taken";
      }
    }
    
    players.add(player);
    return null;
  }
}
