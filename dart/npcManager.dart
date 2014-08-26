part of ld30;

class NPCManager {
  Game game;
  num drag = 0.4;
  List<Enemy> allyPool = new List<Enemy>();

  NPCManager(this.game) {}

  void update() {
    for (int i = 0; i < allyPool.length; i++) {
      if (allyPool[i].ally) allyPool[i].updateAlly();
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
  bool facingRight = false;
  bool grounded = false;
  bool dead = false;
  int deadFrame = 0;
  int originalHeight, originalWidth;

  Game game;
  PIXI.Point position = new PIXI.Point();
  PIXI.Point acceleration = new PIXI.Point();
  List<PIXI.Texture> dyingFrames = [PIXI.Texture.fromFrame("Death1.png"),
                                    PIXI.Texture.fromFrame("Death2.png"),
                                    PIXI.Texture.fromFrame("death3.png")];
  List<PIXI.Texture> idleFrames = [PIXI.Texture.fromFrame("Side View/W1.png")];
  List<PIXI.Texture> runningFrames = [
    PIXI.Texture.fromFrame("Side View/W1.png"),
    PIXI.Texture.fromFrame("Side View/W2.png"),
    PIXI.Texture.fromFrame("Side View/W3.png"),
    PIXI.Texture.fromFrame("Side View/W4.png")];
  PIXI.MovieClip view;

  void die() {
    dead = true;
    view.textures = dyingFrames;
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
    game.gameFront.addChild(view);
  }

  void update() {
    bool currFacingRight = facingRight;

    if (dead) {
      acceleration.x = 0;
    } else {
      if (acceleration.x == 0) view.textures = idleFrames;
      else view.textures = runningFrames;
    }

    view.animationSpeed = game.player.realAnimationSpeed * dt;
    game.collisionManager.floorCheck(this);
    !grounded ? acceleration.y += game.gravity : acceleration.y = 0;

    if (acceleration.x > 0) {
      if (acceleration.x > game.npcManager.drag)
        acceleration.x -= game.npcManager.drag;
      else acceleration.x = 0;
    }
    if (acceleration.x < 0) {
      if (acceleration.x < -game.npcManager.drag) {
        acceleration.x += game.npcManager.drag;
        facingRight = false;
      } else acceleration.x = 0;
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

    if (dead) {
      if (deadFrame < 2 / view.animationSpeed) deadFrame++;
      else view.stop();
    }
  }

  void updateAlly() {
    game.cutsceneManager.updateNPC(this);
  }
}