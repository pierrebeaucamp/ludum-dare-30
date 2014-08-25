part of ld30;

class NPCManager {
  Game game;
  num drag = 0.4;
  List<Enemy> enemyPool = new List<Enemy>();
  List<Enemy> allyPool = new List<Enemy>();

  NPCManager(this.game) {}

  void update() {
    for (int i = 0; i < allyPool.length; i++) {
      allyPool[i].ally ? allyPool[i].updateAlly() : allyPool[i].updateEnemy();
      for (int j = 0; j < allyPool.length; j++) {
        if (i != j && !allyPool[j].dead) {
          if (game.collisionManager.spritesColliding(allyPool[i], allyPool[j]))
            allyPool[i].acceleration.x = 0;
        }
      }
      allyPool[i].update();
    }
  }

  void spawnAlly(num x) {
    allyPool.add(new Enemy(game, x, true));
  }
}

class Enemy {
  bool ally = false;
  bool facingRight = true;
  bool grounded = false;
  bool dead = false;
  int originalHeight, originalWidth;

  Game game;
  PIXI.Point position = new PIXI.Point();
  PIXI.Point acceleration = new PIXI.Point();
  List<PIXI.Texture> dyingFrames = [];
  List<PIXI.Texture> idleFrames = [PIXI.Texture.fromFrame("Panda_0.png")];
  List<PIXI.Texture> runningFrames = [
    PIXI.Texture.fromFrame("Panda_1.png"),
    PIXI.Texture.fromFrame("Panda_2.png"),
    PIXI.Texture.fromFrame("Panda_3.png"),
    PIXI.Texture.fromFrame("Panda_4.png")];
  PIXI.MovieClip view;

  void die() {
    dead = true;
  }

  Enemy(this.game, num x, this.ally) {
    view = new PIXI.MovieClip(idleFrames);
    view.animationSpeed = 0.23;
    view.anchor.x = 0.5;
    view.anchor.y = 0.5;
    view.visible = true;

    originalHeight = view.height;
    originalWidth = view.width;
    view.width = originalWidth * modulo;
    view.height = originalHeight * modulo;
    position.y = game.player.position.y;
    position.x = x;
    view.play();
    game.game.addChild(view);
  }

  void update() {
    if (dead) {
      acceleration.x = 0;
    } else {
      if (acceleration.x == 0) view.textures = idleFrames;
      else view.textures = runningFrames;
    }
    bool currFacingRight = facingRight;
    view.animationSpeed = game.player.realAnimationSpeed * dt;
    game.collisionManager.floorCheck(this);
    !grounded ? acceleration.y += game.gravity : acceleration.y = 0;

    if (acceleration.x > 0) {
      if (acceleration.x > game.npcManager.drag)
        acceleration.x -= game.npcManager.drag;
      else acceleration.x = 0;
    }
    if (acceleration.x < 0) {
      if (acceleration.x < -game.npcManager.drag)
        acceleration.x += game.npcManager.drag;
      else acceleration.x = 0;
    }

    position.y += acceleration.y;

    if (game.player.acceleration.x < 0 &&
        game.player.view.position.x + game.player.acceleration.x *
        modulo < 50 * modulo) {
      position.x += acceleration.x - (modulo / 2) * game.player.acceleration.x / modulo;
    } else if (game.player.acceleration.x > 0 &&
               game.player.view.position.x + game.player.acceleration.x *
               modulo > width / 2) {
      position.x += acceleration.x - (modulo / 2) * game.player.acceleration.x / modulo;
    } else {
      position.x += acceleration.x;
    }

    view.position.x = position.x * modulo;
    view.position.y = position.y * modulo;

    if (currFacingRight != facingRight) {
      view.scale.x *= -1;
      view.position.x = view.width / 2 - view.scale.x * view.width / 2;
    }
  }

  void updateAlly() {
    game.cutsceneManager.updateNPC(this);
  }

  void updateEnemy () {

  }
}