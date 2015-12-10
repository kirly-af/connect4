COL_NB = 7
LINE_NB = 6

init = ->
  connect4.player = 1
  connect4.grid = ((0 for _ in [1..LINE_NB]) for _ in [1..COL_NB])
  connect4.cache = (0 for _ in [1..COL_NB])
  connect4.finished = false
  connect4.count = 0
  return

win = (x, y) ->
  connect4.finished = axeCheck(x, y, 0, 1)
  connect4.finished = axeCheck(x, y, 1, 0)
  connect4.finished = axeCheck(x, y, 1, 1)
  connect4.finished = axeCheck(x, y, -1, 1)
  return connect4.finished

play = (button) ->
  unless connect4.grid[COL_NB - 1][LINE_NB - 1] isnt 0
    column = button.i
    line = connect4.cache[column]
    game.discPut column, line, "p#{connect4.player}"
    connect4.grid[column][line] = connect4.player
    connect4.cache[column] += 1
    connect4.player = if connect4.player is 1 then 2 else 1
    connect4.count += 1
  return win(column, line) or connect4.count is COL_NB * LINE_NB

pause = ->
  ($ '#pause-modal').modal keyboard: false

stop = ->
  alert "Player##{if connect4.player is 1 then 2 else 1} wins !"
  reset()

reset = ->
  init()
  game.reset()

isInGrid = (x, y) -> x >= 0 and x < LINE_NB and y >= 0 and y < COL_NB

axeCheck = (x, y, nextX, nextY) ->
  return true if connect4.finished
  return false if not x? and not y?
  val = connect4.grid[x][y]
  nb = 1
  alignedTrack = (x, y, addX, addY) ->
    x += addX
    y += addY
    while isInGrid(x, y) and connect4.grid[x][y] is val and nb isnt 4
      nb += 1
      x += addX
      y += addY
    return
  alignedTrack x, y, nextX, nextY
  alignedTrack x, y, nextX * -1, nextY * -1 if nb isnt 4
  return nb is 4

init()
game = new connect4.Game 'game-container',
  play: play
  pause: pause
  stop: stop
