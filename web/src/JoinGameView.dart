part of gitoniaclient;


class JoinGameView {
  String _gameId;
  App _app;
  Game _game;
  
  JoinGameView(this._app,this._gameId){
    if(this._gameId != null){
      _app.service.getGameInfo(_gameId, (data){
        _game = new Game.fromMap(data);
      });
    }
  }
  
  Element draw(){
    var allHold = new DivElement();
    var top = new Element.html("""
<div class="join-game-top">
  <div class="container">
    <div class="logo-holder" id="logo-holder"></div>
    <div class="title-holder">
      Conquerors of Gitonia
      <div class="subtitle-holder">A game based on git.</div>
    </div>
  </div>
</div>
""");
    var logoView = new LogoView();
    top.query("#logo-holder").elements.add(logoView.draw());
    allHold.elements.add(top);
    
    var html = new StringBuffer("""
<div class="container">
  <div class="row">
    <div class="span4 offset4 well join-game-box">
      <form id="join-game" class="form">
        <div id="join-game-error"></div>
        <div class="control-group">
          <label class="control-label" for="name">Name</label>
          <div class="controls">
            <input type="text" id="name" placeholder="">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="name">Color</label>
          <div class="controls">

    """);
    for(var i=0;i<PLAYER_COLORS.length;i++){
      html.add("""
    <input type="radio" name="color" class="color-choice" id="player-color-$i" value="$i">
    <label class="radio player-select-color" for="player-color-$i" style="background:${PLAYER_COLORS[i]};"></label>
      """);
    }
    
    var submitText = "Create new game";
    if(_gameId != null){
      submitText = "Join game";
    }
    
    html.add("""
          </div>
        </div>
        <div class="control-group">
          <input type="submit" class="btn" value="$submitText">
        </div>
      </form>
    </div>
  </div>
</div>
    """);
    var element = new Element.html(html.toString());
    element.query("#join-game").on.submit.add((e){
      e.preventDefault();
      _joinGame(element.query("#join-game"));
    });
    allHold.elements.add(element);
    
    return allHold;
  }
  
  void _joinGame(FormElement form){
    var name = form.query("#name").value;
    var selectedColor = form.query(".color-choice:checked");
    if(selectedColor == null || name==""){
      form.query("#join-game-error").innerHTML = "<div class='alert alert-error'>Please enter a name and select a color</div>";
    }else{
      var color = selectedColor.value;
      _app.service.joinGame(_gameId,name,color,(data){
        if(data.containsKey('Error')){
          form.query("#join-game-error").innerHTML = "<div class='alert alert-error'>${data['Error']}</div>";
        }else{
          var game_id;
          if(_gameId!=null){
            game_id = _gameId;
          }else{
            game_id = data['game_id'];
          }
          _app.saveGame(game_id,data['player_id']);
          _app.setCurrentGame(game_id,data['player_id']);
        }
      });
    }
  }
}
