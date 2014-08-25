part of ld30;

class InputHelper {
  Map<int, int> _keys = new Map<int, int>();
  PIXI.DisplayObjectContainer leftTouch = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer rightTouch = new PIXI.DisplayObjectContainer();
  PIXI.DisplayObjectContainer shootTouch = new PIXI.DisplayObjectContainer();
  Game game;

  InputHelper(this.game) {
    window.onKeyDown.listen((KeyboardEvent e) {
      if (!_keys.containsKey(e.keyCode)) _keys[e.keyCode] = e.timeStamp;
    });
    window.onKeyUp.listen((KeyboardEvent e) => _keys.remove(e.keyCode));

    leftTouch.interactive = true;
    leftTouch.hitArea = new PIXI.Rectangle(0, 0, width / 4, height);
    game.game.addChild(leftTouch);
    rightTouch.interactive = true;
    rightTouch.hitArea = new PIXI.Rectangle(width / 4, 0, width / 4, height);
    game.game.addChild(rightTouch);
    shootTouch.interactive = true;
    shootTouch.hitArea = new PIXI.Rectangle(width / 2, 0, width / 2, height);
    game.game.addChild(shootTouch);
  }

  void update() {
    leftTouch.mousedown = leftTouch.touchstart = (d) {
      if (!_keys.containsKey(KeyCode.LEFT)) _keys[KeyCode.LEFT] = null;
    };
    rightTouch.mousedown = rightTouch.touchstart = (d) {
      if (!_keys.containsKey(KeyCode.RIGHT)) _keys[KeyCode.RIGHT] = null;
    };
    shootTouch.mousedown = shootTouch.touchstart = (d) {
      if (!_keys.containsKey(KeyCode.SPACE)) _keys[KeyCode.SPACE] = null;
    };

    leftTouch.mouseup = leftTouch.mouseupoutside = leftTouch.touchend =
                        leftTouch.touchendoutside =
                        (d) => _keys.remove(KeyCode.LEFT);
    rightTouch.mouseup = rightTouch.mouseupoutside = rightTouch.touchend =
                         rightTouch.touchendoutside =
                         (d) => _keys.remove(KeyCode.RIGHT);
    shootTouch.mouseup = shootTouch.mouseupoutside = shootTouch.touchend =
                         shootTouch.touchendoutside =
                         (d) => _keys.remove(KeyCode.SPACE);
  }

  isPressed(int keyCode) => _keys.containsKey(keyCode);
}