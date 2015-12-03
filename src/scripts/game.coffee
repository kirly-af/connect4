class connect4.Game extends Phaser.Game
  constructor: (element) ->
    super window.innerWidth, window.innerHeight, Phaser.AUTO, element,
      preload: => @onPreload()
      create: => @onCreate()
      resize: => @onResize()
    @gameProp =
      ratio: 1
      offsets:
        grid: 90
        gridArea: 63
        disc: 255
        area: 256
      pos:
        x: 0
        y: 0

  fakeIt: ->
    @discPut 0, 0, 'p1'
    @discPut 1, 0, 'p1'
    @discPut 0, 2, 'p2'
    @discPut 0, 3, 'p2'
    @discPut 0, 4, 'p2'

  discPut: (i, j, type, group='discs') ->
    x = @gameProp.offsets.grid + @gameProp.offsets.disc * j
    y = @gameProp.offsets.grid + @gameProp.offsets.disc * (5 - i)
    @gameProp[group].create x, y, type

  onPreload: ->
    @load.image 'grid', 'assets/images/grid.png'
    @load.image 'empty', 'assets/images/empty.png'
    @load.image 'p1', 'assets/images/player1.png'
    @load.image 'p2', 'assets/images/player2.png'
    @load.image 'area', 'assets/images/area.png'
    @load.image 'selected', 'assets/images/selected.png'

  onHover: (area, pointer) ->
    if @gameProp.ignoreHover
      @gameProp.ignoreHover = false
      return
    @gameProp.selected.x = @selectedPosition(area.i)

  onClick: (area, pointer) ->
    @gameProp.ignoreHover = true
    console.log('click:', area.i)

  onCreate: ->
    discsCreate = (i) =>
      @discPut i, j, 'empty', 'grid' for j in [0..6]

    @scale.scaleMode = Phaser.ScaleManager.RESIZE
    @stage.backgroundColor = '#87CEEB'
    @gameProp.grid = @add.group()
    @gameProp.grid.create 0, 0, 'grid'
    discsCreate i for i in [0..5]
    @gameProp.discs = @add.group()
    @gameProp.selected = @add.sprite @selectedPosition(3), 0, 'selected'
    @gameProp.areas = @add.group()
    @areasCreate i for i in [0..6]
    @fakeIt()
    @rescale()
    return

  onResize: -> @rescale()

  rescale: ->
    groupScale = (group, setX=true) =>
      group.scale.setTo @gameProp.ratio, @gameProp.ratio
      group.x = @gameProp.pos.x if setX is true
      group.y = @gameProp.pos.y

    @updateRatio()
    @updatePosition()
    groupScale @gameProp.selected, false
    groupScale @gameProp.grid
    groupScale @gameProp.discs
    groupScale @gameProp.areas
    @scale.refresh()

  areaPosition: (i) ->
    Math.ceil @gameProp.offsets.gridArea + @gameProp.offsets.area * i

  selectedPosition: (i) ->
    @areaPosition(i) / 2 # WTF

  areasCreate: (i) ->
    x = @areaPosition i
    sprite = @gameProp.areas.create x, 0, 'area'
    sprite.inputEnabled = true
    over = (sprite, pointer) => @onHover sprite, pointer
    click = (sprite, pointer) => @onClick sprite, pointer
    sprite.i = i
    sprite.events.onInputOver.add over, @
    sprite.events.onInputDown.add click, @

  getGrid: ->
    if not @gameProp.gridImage?
      @gameProp.gridImage = @cache.getImage 'grid'
    return @gameProp.gridImage

  updatePosition: ->
    img = @getGrid()
    realX = Math.ceil(@gameProp.ratio * img.width)
    realY = Math.ceil(@gameProp.ratio * img.height)
    @gameProp.pos.x = Math.ceil((window.innerWidth - realX) / 2)
    @gameProp.pos.y = Math.ceil((window.innerHeight - realY) / 2)

  updateRatio: ->
    img = @getGrid()
    xRatio = window.innerWidth / img.width
    yRatio = window.innerHeight / img.height
    @gameProp.ratio = if xRatio < yRatio then xRatio else yRatio
