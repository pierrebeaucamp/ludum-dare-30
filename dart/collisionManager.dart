part of ld30;

class CollisionManager {
  Game game;
  CollisionManager(this.game) {}



  void floorCheck(var o) {
    int texelX = (o.view.position.x - o.view.width / 2 - game.world.map.x +
                  10).round();
    int texelY = (game.world.myCanvas.height / modulo - (height % 224) +
                  o.view.position.y + o.view.height / 2).round() +
                  114 * (modulo - 1);
    ImageData texel = game.world.CanvasCtx.getImageData(texelX, texelY, 1, 1);
    if (texel.data.toString() != "[0, 0, 0, 0]") {
      o.grounded = true;
    } else {
      o.grounded = false;
    }
  }
}