part of ld30;

class Player {
  bool dead = false;
  bool facingRight = true;
  bool grounded = false;
  num drag = 0.6;
  num lastBulletShot = 0;
  num maxSpeed = 1;
  int originalHeight, originalWidth;
  int shotDelay = 200;
  num realAnimationSpeed = 0.1;

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

  Player(this.game) {
    view = new PIXI.MovieClip(idleFrames);
    view.animationSpeed = 0.23;
    view.anchor.x = 0.5;
    view.anchor.y = 0.5;
    view.visible = false;

    originalHeight = view.height;
    originalWidth = view.width;
    position.y = 50;
    position.x = 150;
    game.game.addChild(view);
  }

  void update() => dead ? updateDead() : updateAlive();

  void updateAlive() {
    bool currFacingRight = facingRight;
    view.animationSpeed = realAnimationSpeed * dt;
    game.collisionManager.floorCheck(this);
    !grounded ? acceleration.y += game.gravity : acceleration.y = 0;

    if (acceleration.x > 0) {
      acceleration.x > drag ? acceleration.x -= drag : acceleration.x = 0;
    }
    if (acceleration.x < 0) {
      acceleration.x < -drag ? acceleration.x += drag : acceleration.x = 0;
    }

    if (game.inputHelper.isPressed(KeyCode.D) ||
        game.inputHelper.isPressed(KeyCode.RIGHT)) {
      if (acceleration.x <= maxSpeed) acceleration.x += 2;
      facingRight = true;
    }

    if (game.inputHelper.isPressed(KeyCode.A) ||
        game.inputHelper.isPressed(KeyCode.LEFT)) {
      if (acceleration.x >= -maxSpeed) acceleration.x -= 2;
      facingRight = false;
    }

    position.y += acceleration.y;

    view.position.x = position.x * modulo;
    view.position.y = position.y * modulo;

    if (view.position.x + acceleration.x * modulo > width / 2) {
      if (game.camera.x - acceleration.x * modulo < game.world.map.width)
        game.camera.x -= acceleration.x * modulo;
    } else if (view.position.x + acceleration.x * modulo < 50 * modulo) {
      if (game.camera.x - acceleration.x * modulo < 0)
        game.camera.x -= acceleration.x * modulo;
    } else {
      position.x += acceleration.x;
    }

    if (currFacingRight != facingRight) {
      view.scale.x *= -1;
      view.position.x = view.width / 2 - view.scale.x * view.width / 2;
    }

    if (acceleration.x == 0) view.textures = idleFrames;
    else view.textures = runningFrames;

    if (game.inputHelper.isPressed(KeyCode.SPACE) ||
        game.inputHelper.isPressed(KeyCode.ENTER) ||
        game.inputHelper.isPressed(KeyCode.Z) ||
        game.inputHelper.isPressed(KeyCode.X) ||
        game.inputHelper.isPressed(KeyCode.NUM_ZERO) ||
        game.inputHelper.isPressed(KeyCode.SHIFT) ||
        game.inputHelper.isPressed(KeyCode.PERIOD)) {
      if (currentTime - lastBulletShot > shotDelay) {
        game.bulletManager.shoot(view.position.x, view.position.y,
                                 facingRight ? 1 : -1);
        lastBulletShot = currentTime;
      }
    }
  }

  void updateDead() {
  }
}