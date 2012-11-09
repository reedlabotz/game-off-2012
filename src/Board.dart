part of gamelib;

class Board {
  List<int> tiles;
  List<Player> players;
  Player owner;
  String id;
  
  Board(){
    tiles = new List<int>();
    var rand = new Random();
    for(var i=0;i<19;i++){
      tiles.add(rand.nextInt(6));
    }
  }
  
  Element draw(){
    Element holder = new DivElement();
    holder.classes.add('board');
    var num=0;
    for(var x=0;x<TILE_ROWS.length;x++){
      for(var y=0;y<TILE_ROWS[x];y++){
        Element tile = new DivElement();
        Element svg = new SVGElement.svg("""
<svg width="40px" height="36px" viewBox="0 0 40 36"
       xmlns="http://www.w3.org/2000/svg" version="1.1">
    <polygon style="fill:${TILE_COLORS[tiles[num]]}"
             points="10,0 30,0 40,18 30,36 10,36 0,18" />
</svg>
""");
        tile.nodes.add(svg);
        tile.classes.add("tile");
        tile.style.top = "${TILE_ROW_OFFSETS[x]+y*36+1*y}px";
        tile.style.left = "${x*30+1*x}px";
        
        holder.nodes.add(tile);
        num++;
      }
    }
    return holder;
  }
}
