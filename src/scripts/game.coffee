class Game
  constructor: (name) ->
    @ui = new connect4.UI name

g = new Game 'toto'
