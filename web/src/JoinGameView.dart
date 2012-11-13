part of gameclient;


class JoinGameView {
  Game _game;
  
  JoinGameView(this._game);
  
  Element draw(){
    var allHold = new DivElement();
    var top = new Element.html("""
<div class="join-game-top">
  <div class="container">
    <div class="logo-holder" id="logo-holder"></div>
    <div class="title-holder">Conquerors of Gitonia</div>
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
        <div class="control-group">
          <label class="control-label" for="name">Name</label>
          <div class="controls">
            <input type="text" id="name" placeholder="Name">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="name">Color</label>
          <div class="controls">

    """);
    for(var i=0;i<PLAYER_COLORS.length;i++){
      html.add("""
    <input type="radio" name="color" id="player-color-$i" value="$i">
    <label class="radio player-select-color" for="player-color-$i" style="background:${PLAYER_COLORS[i]};"></label>
      """);
    }
    html.add("""
          </div>
        </div>
        <div class="control-group">
          <input type="submit" class="btn">
        </div>
      </form>
    </div>
  </div>
</div>
    """);
    var element = new Element.html(html.toString());
    element.query("#join-game").on.submit.add((e){
      e.preventDefault();
      print("form submitted");
    });
    allHold.elements.add(element);
    return allHold;
  }
}
