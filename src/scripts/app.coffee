COL_NB = 7
LINE_NB = 6

player = 1
grid = [
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
  [0, 0, 0, 0, 0, 0]
]
cache = [0, 0, 0, 0, 0, 0, 0]
finished = false
count = 0

win = (x, y) ->
  finished = axeCheck(x, y, 0, 1)
  finished = axeCheck(x, y, 1, 0)
  finished = axeCheck(x, y, 1, 1)
  finished = axeCheck(x, y, -1, 1)
  return finished

play = (button) ->
  unless grid[COL_NB - 1][LINE_NB - 1] isnt 0
    column = button.i
    line = cache[column]
    game.discPut column, line, "p#{player}"
    grid[column][line] = player
    cache[column] += 1
    player = if player is 1 then 2 else 1
    count += 1
  return win(column, line) or count is COL_NB * LINE_NB

stop = ->
  window.alert "Player##{if player is 1 then 2 else 1} wins !"

isInGrid = (x, y) -> x >= 0 and x < LINE_NB and y >= 0 and y < COL_NB

axeCheck = (x, y, nextX, nextY) ->
  return true if finished
  return false if not x? and not y?
  val = grid[x][y]
  nb = 1
  alignedTrack = (x, y, addX, addY) ->
    x += addX
    y += addY
    while isInGrid(x, y) and grid[x][y] is val and nb isnt 4
      nb += 1
      x += addX
      y += addY
    return
  alignedTrack x, y, nextX, nextY
  alignedTrack x, y, nextX * -1, nextY * -1 if nb isnt 4
  return nb is 4


game = new connect4.Game 'game-container',
  play: play
  stop: stop
