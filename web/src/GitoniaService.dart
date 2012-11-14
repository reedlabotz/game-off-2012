part of gitoniaclient;


class GitoniaService {
  void joinGame(String gameId,String name,String color,callback){
    HttpRequest request = new HttpRequest();
    if(gameId == null){
      request.open("POST", '${API_URL}/game/create',true);
    }else{
      request.open("POST", '${API_URL}/game/${gameId}/player/join', true);
    }
    request.setRequestHeader('Content-type', 'text/json');
    request.on.loadEnd.add((e){
      var data = JSON.parse(request.responseText);
      callback(data);
    });
    request.send(JSON.stringify({'name':name,'color':color}));
  }
  
  void getGameInfo(String gameId,callback){
    HttpRequest request = new HttpRequest();
    request.open("GET", '${API_URL}/game/${gameId}',true);
    request.on.loadEnd.add((e){
      var data = JSON.parse(request.responseText);
      callback(data);
    });
    request.send("");
  }
}
