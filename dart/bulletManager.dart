part of ld30;

class BulletManager {
  Game game;
  List<Bullet> bulletPool = new List<Bullet>();

  BulletManager(this.game) {}

  void update() {
    for (int i = 0; i < bulletPool.length; i++) {
      bulletPool[i].update();
      if (bulletPool[i].destroy) bulletPool.removeAt(i);
    }
  }

  void shoot(num x, y, d) {
    bulletPool.add(new Bullet(game, x, y, d));
  }
}

class Bullet {
  bool destroy = false;
  bool grounded = false;
  bool virgin = true;
  num bulletSpeed = 2.5;
  Game game;
  PIXI.Point acceleration = new PIXI.Point();
  PIXI.Point origSize = new PIXI.Point();
  PIXI.Sprite view = PIXI.Sprite.fromFrame("fireball.png");

  Bullet(this.game, num x, y, d) {
    acceleration.x = d * bulletSpeed * modulo;
    acceleration.y = -bulletSpeed * modulo;
    origSize.x = view.width;
    origSize.y = view.height;
    view.width = origSize.x * modulo;
    view.height = origSize.y * modulo;
    view.position.x = x + d * view.width / 2 - view.width / 2;
    view.position.y = y - view.height / 2 - 5 * modulo;
    game.gameFront.addChild(view);
  }

  void update() {
    game.collisionManager.floorCheck(this);
    if (game.collisionManager.spritesColliding(this, game.player)) {
        if (!virgin) {
          //grounded = true;
          game.player.die();
        }
    } else virgin = false;

    for (var i = 0; i < game.npcManager.allyPool.length; i++) {
      Enemy tempEnemy = game.npcManager.allyPool[i];
      if (game.collisionManager.spritesColliding(this, tempEnemy)) {
        grounded = true;
        tempEnemy.die();
      }
    }

    if (grounded) die();
    acceleration.y += game.gravity * (bulletSpeed / 3) * modulo ;
    view.position.x += acceleration.x;
    view.position.y += acceleration.y;
  }

  void die() {
    destroy = true;
    game.gameFront.removeChild(view);
  }
}