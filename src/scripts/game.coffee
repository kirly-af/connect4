class connect4.Game
  constructor: (width, length) ->
    @phaser = new Phaser.Game width, length, Phaser.AUTO, '',
      preload: @preload
      create: @create
      update: @update

  preload: ->

  create: ->

  update: ->
