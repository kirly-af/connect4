class connect4.Game extends Phaser.Game
  constructor: (element) ->
    super window.innerWidth, window.innerHeight, Phaser.AUTO, element,
      preload: => @onPreload()
      create: => @onCreate()
      resize: => @onResize()
    @gameData =
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
    @discPut 0, 1, 'p1'
    @discPut 2, 0, 'p2'
    @discPut 3, 0, 'p2'
    @discPut 4, 0, 'p2'

  discPut: (i, j, type, group='discs') ->
    x = @gameData.offsets.grid + @gameData.offsets.disc * i
    y = @gameData.offsets.grid + @gameData.offsets.disc * (5 - j)
    @gameData[group].create x, y, type

  onPreload: ->
    @load.image 'grid', 'assets/images/grid.png'
    @load.image 'empty', 'assets/images/empty.png'
    @load.image 'p1', 'assets/images/player1.png'
    @load.image 'p2', 'assets/images/player2.png'
    @load.image 'area', 'assets/images/area.png'
    @load.image 'selected', 'assets/images/selected.png'
    @load.image 'pause', 'assets/images/pause.png'

  pauseState: ->
    console.log 'pause'

  onCreate: ->

    @scale.scaleMode = Phaser.ScaleManager.RESIZE
    @stage.backgroundColor = '#87CEEB'

    @gameData.grid = @add.group()
    @gameData.grid.create 0, 0, 'grid'

    @gameData.buttons = @add.group()
      .add @add.button 10, 10, 'pause', @pauseState, @

    discsCreate = (j) =>
      @discPut i, j, 'empty', 'grid' for i in [0..6]
    discsCreate j for j in [0..5]
    @gameData.discs = @add.group()

    @gameData.selected = @add.group()
    @gameData.transp = @gameData.selected.create @areaPos(3), 50, 'selected'

    @gameData.areas = @add.group()
    @areasCreate i for i in [0..6]

    @fakeIt()
    @onResize()
    return

  onResize: ->
    groupScale = (group, setCoords=true) =>
      group.scale.setTo @gameData.ratio, @gameData.ratio
      if setCoords is true
        group.x = @gameData.pos.x
        group.y = @gameData.pos.y

    @updateRatio()
    @updatePosition()
    groupScale @gameData.buttons, false
    groupScale @gameData.selected
    groupScale @gameData.grid
    groupScale @gameData.discs
    groupScale @gameData.areas
    @scale.refresh()

  areaPos: (i) ->
    Math.ceil @gameData.offsets.gridArea + @gameData.offsets.area * i

  areaHover: (area) ->
    @gameData.transp.x = @areaPos(area.i)

  areaClicked: (area) ->
    if area.i is 0
      @discPut 0, 2, 'p1'                             # TODO remove this

  areasCreate: (i) ->
    x = @areaPos i
    button = @add.button x, 0, 'area', @areaClicked, @
    button.inputEnabled = true
    @gameData.areas.add button
    button.i = i
    over = (button, pointer) => @areaHover button, pointer
    button.events.onInputOver.add over, @

  getGrid: ->
    if not @gameData.gridImage?
      @gameData.gridImage = @cache.getImage 'grid'
    return @gameData.gridImage

  updatePosition: ->
    img = @getGrid()
    realX = Math.ceil(@gameData.ratio * img.width)
    realY = Math.ceil(@gameData.ratio * img.height)
    @gameData.pos.x = Math.ceil((window.innerWidth - realX) / 2)
    @gameData.pos.y = Math.ceil((window.innerHeight - realY) / 2)

  updateRatio: ->
    img = @getGrid()
    xRatio = window.innerWidth / img.width
    yRatio = window.innerHeight / img.height
    @gameData.ratio = if xRatio < yRatio then xRatio else yRatio
