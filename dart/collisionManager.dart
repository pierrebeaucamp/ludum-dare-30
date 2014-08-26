part of ld30;

class CollisionManager {
  Game game;
  CollisionManager(this.game) {}

  bool spritesColliding(var a, b) {
    return ((a.view.position.x - b.view.position.x).abs() * 2.5 <
           (a.view.width.abs() + b.view.width.abs())) &&
           ((a.view.position.y - b.view.position.y).abs() * 2.5 <
           (a.view.height.abs() + b.view.height.abs()));
  }

  bool enemyInFrame(var a, b) {
    return false;
  }

  void floorCheck(var o) {
    int texelX = (o.view.position.x - o.view.width / 2 - game.world.map.x +
                  10).round();
    int texelY = (game.world.myCanvas.height / modulo - (height % 224) +
                  o.view.position.y + o.view.height / 2).round() +
                  224 * (modulo - 1);
    ImageData texel = game.world.CanvasCtx.getImageData(texelX, texelY, 1, 1);
    if (texel.data.toString() != "[0, 0, 0, 0]") o.grounded = true;
    else o.grounded = false;

    if (!(o is Bullet)) {
      texel = game.world.CanvasCtx.getImageData(texelX, texelY - 2, 1, 1);
      if (texel.data.toString() != "[0, 0, 0, 0]") {
        o.position.y -= 1;
        o.acceleration.y = game.gravity * -2;
      }
    }
  }
}