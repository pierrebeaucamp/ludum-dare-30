part of ld30;

class Game {
  BulletManager bulletManager;
  CollisionManager collisionManager;
  CutsceneManager cutsceneManager;
  InputHelper inputHelper;
  NPCManager npcManager;
  Player player;
  World world;
  PIXI.Point camera = new PIXI.Point();
  PIXI.Text startText = new PIXI.Text("This Game is unfinished\n\n" +
                                      " Click or touch to start!",
                                      new PIXI.TextStyle()
                                      ..font = "bold 35px Arial"
                                      ..fill = "white");
  PIXI.DisplayObjectContainer container = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer game = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer gameFront = new PIXI.DisplayObjectContainer();

  num gravity = 0.098;

  Game() {
    bulletManager = new BulletManager(this);
    collisionManager = new CollisionManager(this);
    cutsceneManager = new CutsceneManager(this);
    inputHelper = new InputHelper(this);
    player = new Player(this);
    world = new World(this);
    npcManager = new NPCManager(this);

    container.hitArea = stage.hitArea;
    container.interactive = true;
    container.addChild(gameFront);
    container.addChild(game);
    container.addChild(startText);
    stage.addChild(container);
  }

  void update() {
    startText.x = width / 2 - startText.width / 2;
    startText.y = height / 2 - startText.height / 2;

    cutsceneManager.update();
    world.update();
    if (currentState != states["paused"]) {
      player.update();
      npcManager.update();
      bulletManager.update();
      npcManager.update();
    } else {

    }
    inputHelper.update();
  }
}