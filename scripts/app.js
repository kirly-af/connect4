(function() {
  window.connect4 = {};

}).call(this);

(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  connect4.Game = (function(superClass) {
    extend(Game, superClass);

    function Game(element, logic) {
      Game.__super__.constructor.call(this, window.innerWidth, window.innerHeight, Phaser.AUTO, element, {
        preload: (function(_this) {
          return function() {
            return _this.onPreload();
          };
        })(this),
        create: (function(_this) {
          return function() {
            return _this.onCreate();
          };
        })(this),
        resize: (function(_this) {
          return function() {
            return _this.onResize();
          };
        })(this)
      });
      this.gameData = {
        logic: logic,
        finished: false,
        ratio: 1,
        offsets: {
          grid: 90,
          gridcolumn: 63,
          disc: 255,
          column: 256
        },
        pos: {
          x: 0,
          y: 0
        }
      };
    }

    Game.prototype.discPut = function(i, j, type, group) {
      var x, y;
      if (group == null) {
        group = 'discs';
      }
      x = this.gameData.offsets.grid + this.gameData.offsets.disc * i;
      y = this.gameData.offsets.grid + this.gameData.offsets.disc * (5 - j);
      return this.gameData[group].create(x, y, type);
    };

    Game.prototype.reset = function() {
      var discs;
      discs = this.gameData.discs.children;
      while (discs.length !== 0) {
        discs.pop().destroy();
      }
      this.gameData.finished = false;
    };

    Game.prototype.onPreload = function() {
      this.load.image('grid', 'assets/images/grid.png');
      this.load.image('empty', 'assets/images/empty.png');
      this.load.image('p1', 'assets/images/player1.png');
      this.load.image('p2', 'assets/images/player2.png');
      this.load.image('column', 'assets/images/column.png');
      this.load.image('selected', 'assets/images/selected.png');
      this.load.image('pause', 'assets/images/pause.png');
      this.load.image('undo', 'assets/images/undo.png');
      return this.load.image('help', 'assets/images/help.png');
    };

    Game.prototype.pauseClicked = function() {
      return this.gameData.logic.pause();
    };

    Game.prototype.undoClicked = function() {
      var sprite;
      this.gameData.logic.undo();
      sprite = this.gameData.discs.children.pop();
      if (sprite != null) {
        return sprite.destroy();
      }
    };

    Game.prototype.helpClicked = function() {
      return this.gameData.logic.help();
    };

    Game.prototype.onCreate = function() {
      var discsCreate, i, j, k, l;
      this.scale.scaleMode = Phaser.ScaleManager.RESIZE;
      this.stage.backgroundColor = '#87CEEB';
      this.gameData.grid = this.add.group();
      this.gameData.grid.create(0, 0, 'grid');
      discsCreate = (function(_this) {
        return function(j) {
          var i, k, results;
          results = [];
          for (i = k = 0; k <= 6; i = ++k) {
            results.push(_this.discPut(i, j, 'empty', 'grid'));
          }
          return results;
        };
      })(this);
      for (j = k = 0; k <= 5; j = ++k) {
        discsCreate(j);
      }
      this.gameData.discs = this.add.group();
      this.gameData.selected = this.add.group();
      this.gameData.transp = this.gameData.selected.create(this.columnPos(3), 50, 'selected');
      this.gameData.columns = this.add.group();
      for (i = l = 0; l <= 6; i = ++l) {
        this.columnsCreate(i);
      }
      this.gameData.buttons = this.add.group();
      this.gameData.buttons.add(this.add.button(10, 10, 'pause', this.pauseClicked, this));
      this.gameData.buttons.add(this.add.button(10, 210, 'undo', this.undoClicked, this));
      this.gameData.buttons.add(this.add.button(10, 410, 'help', this.helpClicked, this));
      this.gameData.buttons.alpha = 0.6;
      this.onResize();
    };

    Game.prototype.onResize = function() {
      var groupScale;
      groupScale = (function(_this) {
        return function(group, setCoords) {
          if (setCoords == null) {
            setCoords = true;
          }
          group.scale.setTo(_this.gameData.ratio, _this.gameData.ratio);
          if (setCoords === true) {
            group.x = _this.gameData.pos.x;
            return group.y = _this.gameData.pos.y;
          }
        };
      })(this);
      this.updateRatio();
      this.updatePosition();
      groupScale(this.gameData.buttons, false);
      groupScale(this.gameData.selected);
      groupScale(this.gameData.grid);
      groupScale(this.gameData.discs);
      groupScale(this.gameData.columns);
      return this.scale.refresh();
    };

    Game.prototype.columnPos = function(i) {
      return Math.ceil(this.gameData.offsets.gridcolumn + this.gameData.offsets.column * i);
    };

    Game.prototype.columnHover = function(column) {
      return this.gameData.transp.x = this.columnPos(column.i);
    };

    Game.prototype.columnClicked = function(column) {
      if (this.gameData.finished) {
        return;
      }
      this.gameData.finished = this.gameData.logic.play(column);
      if (this.gameData.finished) {
        return window.setTimeout((function(_this) {
          return function() {
            return _this.gameData.logic.stop();
          };
        })(this), 300);
      }
    };

    Game.prototype.columnsCreate = function(i) {
      var button, over, x;
      x = this.columnPos(i);
      button = this.add.button(x, 0, 'column', this.columnClicked, this);
      button.inputEnabled = true;
      this.gameData.columns.add(button);
      button.i = i;
      over = (function(_this) {
        return function(button, pointer) {
          return _this.columnHover(button, pointer);
        };
      })(this);
      return button.events.onInputOver.add(over, this);
    };

    Game.prototype.getGrid = function() {
      if (this.gameData.gridImage == null) {
        this.gameData.gridImage = this.cache.getImage('grid');
      }
      return this.gameData.gridImage;
    };

    Game.prototype.updatePosition = function() {
      var img, realX, realY;
      img = this.getGrid();
      realX = Math.ceil(this.gameData.ratio * img.width);
      realY = Math.ceil(this.gameData.ratio * img.height);
      this.gameData.pos.x = Math.ceil((window.innerWidth - realX) / 2);
      return this.gameData.pos.y = Math.ceil((window.innerHeight - realY) / 2);
    };

    Game.prototype.updateRatio = function() {
      var img, xRatio, yRatio;
      img = this.getGrid();
      xRatio = window.innerWidth / img.width;
      yRatio = window.innerHeight / img.height;
      return this.gameData.ratio = xRatio < yRatio ? xRatio : yRatio;
    };

    return Game;

  })(Phaser.Game);

}).call(this);

(function() {
  var COLORS, COL_NB, LINE_NB, axisCheck, help, init, isInGrid, listen, nextTurn, pause, play, reset, run, stop, undo, win;

  COL_NB = 7;

  LINE_NB = 6;

  COLORS = ['#AD9008', '#AD0808'];

  run = function() {
    listen();
    init();
    connect4.game = new connect4.Game('game-container', {
      play: play,
      pause: pause,
      stop: stop,
      undo: undo,
      help: help
    });
  };

  init = function() {
    var _;
    connect4.player = 1;
    connect4.grid = (function() {
      var i, ref, results;
      results = [];
      for (_ = i = 1, ref = COL_NB; 1 <= ref ? i <= ref : i >= ref; _ = 1 <= ref ? ++i : --i) {
        results.push((function() {
          var j, ref1, results1;
          results1 = [];
          for (_ = j = 1, ref1 = LINE_NB; 1 <= ref1 ? j <= ref1 : j >= ref1; _ = 1 <= ref1 ? ++j : --j) {
            results1.push(0);
          }
          return results1;
        })());
      }
      return results;
    })();
    connect4.cache = (function() {
      var i, ref, results;
      results = [];
      for (_ = i = 1, ref = COL_NB; 1 <= ref ? i <= ref : i >= ref; _ = 1 <= ref ? ++i : --i) {
        results.push(0);
      }
      return results;
    })();
    connect4.turns = [];
    connect4.finished = false;
    connect4.count = 0;
  };

  win = function(x, y) {
    var axis, i, len, ref;
    ref = [
      {
        x: 0,
        y: 1
      }, {
        x: 1,
        y: 0
      }, {
        x: 1,
        y: 1
      }, {
        x: -1,
        y: 1
      }
    ];
    for (i = 0, len = ref.length; i < len; i++) {
      axis = ref[i];
      connect4.finished = axisCheck(x, y, axis.x, axis.y);
    }
    return connect4.finished;
  };

  play = function(button) {
    var column, line;
    if (connect4.grid[COL_NB - 1][LINE_NB - 1] === 0) {
      column = button.i;
      line = connect4.cache[column];
      connect4.game.discPut(column, line, "p" + connect4.player);
      connect4.grid[column][line] = connect4.player;
      connect4.cache[column] += 1;
      nextTurn(column, line);
      connect4.count += 1;
    }
    return win(column, line) || connect4.count === COL_NB * LINE_NB;
  };

  pause = function() {
    return (jQuery('#pause-modal')).modal({
      keyboard: false
    });
  };

  help = function() {
    return (jQuery('#help-modal')).modal();
  };

  stop = function() {
    nextTurn();
    (jQuery('#win-text #winner')).css('color', COLORS[connect4.player - 1]);
    (jQuery('#win-text #winner')).text(connect4.player);
    return (jQuery('#win-modal')).modal({
      backdrop: 'static',
      keyboard: false
    });
  };

  undo = function() {
    var last;
    last = connect4.turns.pop();
    if (last != null) {
      connect4.grid[last.x][last.y] = 0;
      connect4.cache[last.x] -= 1;
      return nextTurn();
    }
  };

  reset = function() {
    init();
    return connect4.game.reset();
  };

  listen = function() {
    return (jQuery('.game-modal button[name="restart"]')).click(reset);
  };

  isInGrid = function(x, y) {
    return x >= 0 && x < COL_NB && y >= 0 && y < LINE_NB;
  };

  axisCheck = function(x, y, nextX, nextY) {
    var alignedTrack, nb, val;
    if (connect4.finished) {
      return true;
    }
    if ((x == null) && (y == null)) {
      return false;
    }
    val = connect4.grid[x][y];
    nb = 1;
    alignedTrack = function(x, y, addX, addY) {
      x += addX;
      y += addY;
      while (isInGrid(x, y) && connect4.grid[x][y] === val && nb !== 4) {
        nb += 1;
        x += addX;
        y += addY;
      }
    };
    alignedTrack(x, y, nextX, nextY);
    if (nb !== 4) {
      alignedTrack(x, y, nextX * -1, nextY * -1);
    }
    return nb === 4;
  };

  nextTurn = function(x, y) {
    connect4.player = connect4.player === 1 ? 2 : 1;
    if ((x != null) && (y != null)) {
      return connect4.turns.push({
        x: x,
        y: y
      });
    }
  };

  (jQuery(document)).ready(run);

}).call(this);
