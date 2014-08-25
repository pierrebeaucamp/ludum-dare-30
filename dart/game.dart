part of ld30;

class Game {
  CollisionManager collisionManager;
  InputHelper inputHelper;
  NPCManager npcManager;
  Player player;
  World world;
  PIXI.Point camera = new PIXI.Point();
  PIXI.DisplayObjectContainer container = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer game = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer gameFront = new PIXI.DisplayObjectContainer();

  num gravity = 0.098;

  Game() {
    collisionManager = new CollisionManager(this);
    inputHelper = new InputHelper(this);
    npcManager = new NPCManager(this);
    player = new Player(this);
    world = new World(this);

    player.view.play();
    player.view.visible = true;

    container.hitArea = stage.hitArea;
    container.interactive = true;
    container.addChild(gameFront);
    container.addChild(game);
    stage.addChild(container);
  }

  void update() {
    if (currentState != states["paused"]) {
      player.update();
      collisionManager.update();
      world.update();
      npcManager.update();
    }
    inputHelper.update();
  }
}