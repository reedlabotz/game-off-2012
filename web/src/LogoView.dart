part of gameclient;


class LogoView {
  Element draw(){
    // Hex math http://mvdwege.wordpress.com/2011/07/07/math-for-fun/
    var a = LARGE_LOGO_HEIGHT/2;
    var b = a/2;
    var c = a*sqrt(3)/2;
    var height = LARGE_LOGO_HEIGHT;
    var width = 2*c;
    var points = "0,${b} ${c},0 ${2*c},${b} ${2*c},${b+a} ${c},${2*b+a} 0,${b+a}";
    var random = new Random();
    
    Element svg = new SVGElement.svg("""
        <svg width="${width}px" height="${height}px" viewBox="0 0 $width $height" xmlns="http://www.w3.org/2000/svg" version="1.1">
        <polygon style="fill:${TILE_COLORS[random.nextInt(TILE_COLORS.length)]}" points="$points" />
        <mask>
          <polygon style="fill:${TILE_COLORS[random.nextInt(TILE_COLORS.length)]}" points="$points" />
        </mask>
        <line x1="${c/2}" y1="${b/2}" x2="${c+c/2}" y2="${b+a/2}" stroke="#ffffff" stroke-width="${height/20}" />
        <line x1="${c}" y1="${3*b/4+a/4}" x2="${c}" y2="${a+b}" stroke="#ffffff" stroke-width="${height/20}" />
        <circle cx="${c}" cy="${3*b/4+a/4}" fill="#ffffff" r="${height/15}" />
        <circle cx="${c+c/2}" cy="${b+a/2}" fill="#ffffff" r="${height/15}" />
        <circle cx="${c}" cy="${a+b}" fill="#ffffff" r="${height/15}" />
        </svg>
    """);
    
    return svg;
  }
}
