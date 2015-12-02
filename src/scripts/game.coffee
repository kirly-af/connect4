class connect4.Game extends Phaser.Game
  constructor: (element) ->
    super window.innerWidth, window.innerHeight, Phaser.AUTO, element,
      preload: => @onPreload()
      create: => @onCreate()
      update: => @onUpdate()
      resize: => @onResize()
    @ratio = 1
    @gridOffset = 90
    @coinOffset = 250
    @pos =
      x: 0
      y: 0

  rescale: ->
    @updateRatio()
    @updatePosition()
    @gameWorld.scale.setTo @ratio, @ratio
    @gameWorld.x = @pos.x
    @gameWorld.y = @pos.y
    @scale.refresh()

  onPreload: ->
    @load.image 'grid', 'assets/images/grid.png'
    @load.image 'empty', 'assets/images/empty.png'
    @load.image 'p1', 'assets/images/player1.png'
    @load.image 'p2', 'assets/images/player2.png'

  discCreate: (i, j, type) ->
    x = @gridOffset + @coinOffset * j
    y = @gridOffset + @coinOffset * (5 - i)
    @gameWorld.create x, y, type

  gameCreate: ->
    fillGame = (i) =>
      # @discCreate i, j for j in [0..6]          #TODO: correct fail
      @discCreate i, j, 'empty' for j in [0..6]

    @gameWorld = @add.group()
    @gameWorld.create 0, 0, 'grid'
    fillGame i for i in [0..5]

  onCreate: ->
    @scale.scaleMode = Phaser.ScaleManager.RESIZE
    @stage.backgroundColor = '#87CEEB'
    @gameCreate()
    @discCreate 0, 2, 'p1'
    @rescale()

  onUpdate: ->
    return

  onResize: ->
    @rescale()

  getGrid: ->
    if not @grid?
      @grid = @cache.getImage 'grid'
    return @grid

  updatePosition: ->
    img = @getGrid()
    realX = Math.ceil(@ratio * img.width)
    realY = Math.ceil(@ratio * img.height)
    @pos.x = Math.ceil((window.innerWidth - realX) / 2)
    @pos.y = Math.ceil((window.innerHeight - realY) / 2)

  updateRatio: ->
    img = @getGrid()
    xRatio = window.innerWidth / img.width
    yRatio = window.innerHeight / img.height
    @ratio = if xRatio < yRatio then xRatio else yRatio
