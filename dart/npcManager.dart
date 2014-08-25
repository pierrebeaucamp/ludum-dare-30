part of ld30;

class NPCManager {
  Game game;
  var npcs = [];

  NPCManager(this.game) {}

  void update() {

  }
}

class Enemy {
  Game game;
  PIXI.Point position = new PIXI.Point();
  List<PIXI.Texture> dyingFrames = [];
  List<PIXI.Texture> idleFrames = [];
  List<PIXI.Texture> runningFrames = [
    PIXI.Texture.fromFrame("Panda_1.png"),
    PIXI.Texture.fromFrame("Panda_2.png"),
    PIXI.Texture.fromFrame("Panda_3.png"),
    PIXI.Texture.fromFrame("Panda_4.png")];
  PIXI.MovieClip view;

  Enemy(this.game){}
}