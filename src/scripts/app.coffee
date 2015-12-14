COL_NB = 7
LINE_NB = 6
COLORS = [ '#AD9008', '#AD0808' ]

run = ->
  listen()
  init()
  connect4.game = new connect4.Game 'game-container',
    play: play
    pause: pause
    stop: stop
    undo: undo
    help: help
  return

init = ->
  connect4.player = 1
  connect4.grid = ((0 for _ in [1..LINE_NB]) for _ in [1..COL_NB])
  connect4.cache = (0 for _ in [1..COL_NB])
  connect4.turns = []
  connect4.finished = false
  connect4.count = 0
  return

win = (x, y) ->
  connect4.finished = axisCheck(x, y, axis.x, axis.y) for axis in [
    { x: 0, y: 1 }
    { x: 1, y: 0 }
    { x: 1, y: 1 }
    { x: -1, y: 1 }
  ]
  return connect4.finished

play = (button) ->
  column = button.i
  unless connect4.grid[column][LINE_NB - 1] isnt 0
    line = connect4.cache[column]
    connect4.game.discPut column, line, "p#{connect4.player}"
    connect4.grid[column][line] = connect4.player
    connect4.cache[column] += 1
    nextTurn column, line
    connect4.count += 1
  return win(column, line) or connect4.count is COL_NB * LINE_NB

pause = -> (jQuery '#pause-modal').modal keyboard: false

help = -> (jQuery '#help-modal').modal()

stop = ->
  nextTurn()
  (jQuery '#win-text #winner').css 'color', COLORS[connect4.player - 1]
  (jQuery '#win-text #winner').text connect4.player
  (jQuery '#win-modal').modal
    backdrop: 'static'
    keyboard: false

undo = ->
  last = connect4.turns.pop()
  if last?
    connect4.grid[last.x][last.y] = 0
    connect4.cache[last.x] -= 1
    nextTurn()

reset = ->
  init()
  connect4.game.reset()

listen = ->
  (jQuery '.game-modal button[name="restart"]').click reset

isInGrid = (x, y) -> x >= 0 and x < COL_NB and y >= 0 and y < LINE_NB

axisCheck = (x, y, nextX, nextY) ->
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

nextTurn = (x, y) ->
  connect4.player = if connect4.player is 1 then 2 else 1
  connect4.turns.push(x: x, y: y) if x? and y?

(jQuery document).ready run
