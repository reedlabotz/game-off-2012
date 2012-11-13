part of gamelib;

class Game {
  Board master;
  List<Board> forks;
  List<Player> players;
  int currentPlayer;
  int round;
  int roll;
  String id;
  int status;
  List<int> tiles;
  
  Game(){
    forks = new List<Board>();
    players = new List<Player>();
    currentPlayer = 0;
    master = new Board(null,players);
    round = -2;
    roll = null;
    id = new Uuid().v4();
    status = STATUS_WAITING_FOR_PLAYERS;
    
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
      var player = new Player.fromMap(d);
      players.add(player);
    }
    
    master = new Board.fromMap(data['master'],players);
    forks = new List<Board>();
    for(var d in data['forks']){
      forks.add(new Board.fromMap(d,players));
    }
    
    round = data['round'];
    roll = data['roll'];
    id = data['id'];
    status = data['status'];
    tiles = data['tiles'];
    currentPlayer = data['current_player'];
  }
  
  Map toMap(){
    return {
      'master': master.toMap(),
      'forks': forks.map((fork) => fork.toMap()),
      'players': players.map((player) => player.toMap()),
      'round': round,
      'roll': roll,
      'id': id,
      'status': status,
      'current_player': currentPlayer,
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
  
  String makeMove(Map move){
    var type = int.parse(move['type']);
    switch(type){
      case MOVE_TYPE_START_GAME:
        return _start();
      default:
        return "Unknown move";
    }
    return null;
  }
  
  String _start(){
    if(players.length < MIN_GAME_PLAYERS){
      return "Too few players";
    }
    
    if(status != STATUS_WAITING_FOR_PLAYERS){
      return "Game has already started";
    }
    
    status = STATUS_PLAYING;
    
    // Randomize the order of the players
    // Adapted from the javascript implementation at http://sedition.com/perl/javascript-fy.html
    var random = new Random();
    var i = players.length;

    while(--i > -1){
        var j = (random.nextDouble() * (i+1)).floor().toInt();
        var tempi = players[i];
        var tempj = players[j];
        players[i] = tempj;
        players[j] = tempi;
    }
    
    return null;
  }
  
  Player getCurrentPlayer(){
    return players[currentPlayer];
  }
}
