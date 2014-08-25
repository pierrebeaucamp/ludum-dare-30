part of ld30;

class World {
  Game game;
  int originalHeight, originalWidth;
  PIXI.Sprite map = PIXI.Sprite.fromFrame("world.png");
  CanvasElement myCanvas;
  CanvasRenderingContext2D CanvasCtx;

  World(this.game) {
    originalHeight = map.height;
    originalWidth = map.width;

    myCanvas = new CanvasElement(width: map.width, height: map.height);
    CanvasCtx = myCanvas.context2D;
    CanvasCtx.drawImageScaled(worldColl, 0, 0, map.width, map.height);
    game.gameFront.addChild(map);
  }

  void update() {
    map.x = game.camera.x - 10;
    height <= 224 ? map.y = game.camera.y + 5 : map.y = game.camera.y + 10;
  }
}