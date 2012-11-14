part of gitoniaclient;

class GameView {
  App _app;
  Game _game;
  
  GameView(this._app,this._game){
    
  }
  
  Element draw(){
    return new Element.html("<h1>Game</h1>");
  }
  
  Element _drawBoard(Board board){
    // Hex math http://mvdwege.wordpress.com/2011/07/07/math-for-fun/
    var a = SMALL_TILE_HEIGHT/2;
    var b = a/2;
    var c = a*sqrt(3)/2;
    var height = SMALL_TILE_HEIGHT;
    var width = 2*c;
    var points = "0,${b} ${c},0 ${2*c},${b} ${2*c},${b+a} ${c},${2*b+a} 0,${b+a}";
    var spacing = SMALL_TILE_SPACING;
    
    
    Element holder = new DivElement();
    holder.classes.add('board');
    var num=0;
    for(var row=0;row<TILE_ROWS.length;row++){
      for(var col=0;col<TILE_ROWS[row];col++){
        Element tile = new DivElement();
        Element svg = new SVGElement.svg("""
<svg width="${width}px" height="${height}px" viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg" version="1.1">
  <polygon style="fill:${TILE_COLORS[_game.tiles[num]]}" points="$points" />
</svg>
""");
        tile.nodes.add(svg);
        tile.classes.add("tile");
        tile.style.width = "${width}px";
        tile.style.height = "${height}px";
        tile.style.top = "${row*(3*b+spacing)}px";
        tile.style.left = "${TILE_ROW_OFFSETS[row]*(c+spacing/2)+(width+spacing)*col}px";
        
        holder.nodes.add(tile);
        num++;
      }
    }
    return holder;
  }
}
