class connect4.Game extends Phaser.Game
  constructor: (element) ->
    super window.innerWidth, window.innerHeight, Phaser.AUTO, element,
      preload: => @onPreload()
      create: => @onCreate()
      update: => @onUpdate()
      resize: => @onResize()
    @ratio = 1

  updateRatio: ->
    prevRatio = @ratio
    img = @cache.getImage 'grid'
    xRatio = window.innerWidth / img.width
    yRatio = window.innerHeight / img.height
    @ratio = if xRatio < yRatio then xRatio else yRatio
    return prevRatio isnt @ratio

  rescale: ->
    # sprite.scale.setTo(@ratio, @ratio) for sprite in @sprites
    @gameWorld.scale.setTo @ratio, @ratio
    @scale.refresh()

  onPreload: ->
    @load.image 'grid', 'assets/images/grid.png'
    @load.image 'p1', 'assets/images/player1.png'
    @load.image 'p2', 'assets/images/player2.png'

  onCreate: ->
    @updateRatio()
    @scale.scaleMode = Phaser.ScaleManager.RESIZE
    @stage.backgroundColor = '#87CEEB'
    @gameWorld = @add.group()
    @gameWorld.create 0, 0, 'grid'
    @gameWorld.create 90, 90, 'p1'
    @rescale()

  onUpdate: ->
    return

  onResize: ->
    @updateRatio()
    @rescale()
