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
  int bulletSpeed = 9;
  Game game;
  PIXI.Point acceleration = new PIXI.Point();
  PIXI.Point origSize = new PIXI.Point();
  PIXI.Sprite view = PIXI.Sprite.fromFrame("Panda_0.png");

  Bullet(this.game, num x, y, d) {
    acceleration.x = d * bulletSpeed;
    acceleration.y = -bulletSpeed;
    origSize.x = view.width;
    origSize.y = view.height;
    view.width = origSize.x * modulo;
    view.height = origSize.y * modulo;
    view.position.x = x;
    view.position.y = y - view.height / 2;
    game.game.addChild(view);
  }

  void update() {
    game.collisionManager.floorCheck(this);
    if (grounded) die();
    acceleration.y += game.gravity * bulletSpeed / 3;
    view.position.x += acceleration.x;
    view.position.y += acceleration.y;
  }

  void die() {
    destroy = true;
    game.game.removeChild(view);
  }
}