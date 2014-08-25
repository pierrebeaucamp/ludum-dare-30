part of ld30;

class CutsceneManager {
  bool initialized = false;
  bool playing = false;
  int scene = 0;
  PIXI.Point startCamera;

  Game game;
  final Map<String, int> cutscenes = {
    "tap": 0,
    "intro": 1,
    "battlefield": 2,
    "mercy": 3,
    "sourrounded": 4,
    "final_choice": 5,
    "outro_good": 6,
    "outro_bad": 7,
    "Dying": 8
  };

  CutsceneManager(this.game) {}

  void play(int s) {
    if (!playing) {
      playing = true;
      initialized = false;
      scene = s;
    }
  }

  void update() {
    if (playing) {
      switch (scene) {
        case 0:
          Element body = querySelector("body");
          body.onTouchStart.first.then((e) {
            body.requestFullscreen();
            playing = false;
            game.cutsceneManager.play(game.cutsceneManager.cutscenes["intro"]);
          });
          body.onMouseDown.first.then((e) {
            playing = false;
            game.cutsceneManager.play(game.cutsceneManager.cutscenes["intro"]);
          });
          break;

        case 1: // intro
          if (!initialized) intro_init();
          if (game.camera.y > startCamera.y) game.camera.y -= 5;
          if (game.camera.y == startCamera.y) {
            game.player.view.visible = true;
            currentState = states["playing"];
            for (var i = 1; i <= 5; i++) {
              game.npcManager.spawnAlly(game.player.position.x + 25 * i);
            }
            playing = false;
          }
          break;

        case 2: // battlefield
          break;
        case 3: // mercy
          break;
        case 4: // sourrounded
          break;
        case 5: // final_choice
          break;
        case 6: // outro_good
          break;
        case 7: // outro_bad
          break;
        case 8: // dying
          break;
        default:
          break;
      }
    }
  }

  void updateNPC(Enemy enemy) {
    switch (scene) {
      case 0:
        break;

      case 1: // intro
        //if ((enemy.view.position.x - game.camera.x) / modulo < 600)
            enemy.acceleration.x = game.player.maxSpeed;
        break;

      case 2: // battlefield
        break;
      case 3: // mercy
        break;
      case 4: // sourrounded
        break;
      case 5: // final_choice
        break;
      case 6: // outro_good
        break;
      case 7: // outro_bad
        break;
      case 8: // dying
        break;
      default:
        break;
    }
  }

  void intro_init() {
    startCamera = new PIXI.Point(game.camera.x, game.camera.y);
    game.container.removeChild(game.startText);
    currentState = states["paused"];
    game.camera.y = 0;
    initialized = true;
  }
}
