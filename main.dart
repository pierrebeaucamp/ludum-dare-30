library ld30;

import "dart:html";
import 'dart:web_audio';
import 'package:play_pixi/pixi.dart' as PIXI;

part "dart/bulletManager.dart";
part "dart/collisionManager.dart";
part "dart/game.dart";
part "dart/inputHelper.dart";
part "dart/npcManager.dart";
part "dart/player.dart";
part "dart/world.dart";

Game game = new Game();
ImageElement worldColl = new ImageElement(src: "assets/world-collision.png");
PIXI.AssetLoader loader = new PIXI.AssetLoader(["assets/sprites.json"]);
PIXI.Stage stage = new PIXI.Stage(0x0000FF, true);
var renderer = PIXI.autoDetectRenderer(600, 800);

var states = {
  "playing" : 1,
  "dead"    : 2,
  "end"     : 3,
  "paused"  : 4,
};

int currentState;
num currentTime;
num dt, lastTime = 0;
int modulo = 0;
int width, height;
bool _initialized = false;

void animate(num time) {
  currentTime = time;
  num passedTime = currentTime - lastTime;
  if (passedTime > 100) passedTime = 100;
  dt = passedTime * 0.06;
  game.update();
  renderer.render(stage);
  PIXI.requestAnimFrame(animate);
  lastTime = currentTime;
}

void main() {
  renderer.view.style.display = "none";
  renderer.view.style.position = "absolute";
  document.body.append(renderer.view);

  AudioContext audioContext = new AudioContext();

  int loaded = 0;
  loader.onProgress = (_) => loaded++;

  loader.onComplete = () {
    _initialized = true;
    currentState = states["playing"];
    resize();
    renderer.view.style.display = "block";
    PIXI.requestAnimFrame(animate);
  };

  worldColl.onLoad.listen((_) => loader.load());

  window.onResize.listen(resize);
  window.addEventListener("orientationchange", resize);
}

void resize([_]) {
  window.innerWidth > 1920 ? width = 1920 : width = window.innerWidth;
  window.innerHeight > 1080 ? height = 1080 : height = window.innerHeight;

  modulo = height ~/ 224 + 1;
  print("Scale: " + modulo.toString());

  game.player.view.height = game.player.originalHeight * modulo;
  game.player.view.width = game.player.originalWidth * modulo;
  game.player.position.y /= modulo;

  game.world.map.height = game.world.originalHeight * modulo;
  game.world.map.width = game.world.originalWidth * modulo;
  game.camera.y = height - 340 * modulo;

  game.world.myCanvas.height = game.world.map.height.round();
  game.world.myCanvas.width = game.world.map.width.round();
  game.world.CanvasCtx.drawImageScaled(worldColl, 0, 0, game.world.map.width,
                                                        game.world.map.height);

  game.inputHelper.leftTouch.hitArea = new PIXI.Rectangle(0, 0,
                                                          width / 4, height);
  game.inputHelper.rightTouch.hitArea = new PIXI.Rectangle(width / 4, 0,
                                                           width / 4, height);
  game.inputHelper.shootTouch.hitArea = new PIXI.Rectangle(width / 2, 0,
                                                           width / 2, height);

  for (var i = 0; i < game.bulletManager.bulletPool.length; i++) {
    Bullet tempBullet = game.bulletManager.bulletPool[i];
    tempBullet.view.width = tempBullet.origSize.x * modulo;
    tempBullet.view.height = tempBullet.origSize.y * modulo;
  }

  renderer.resize(width, height);
}