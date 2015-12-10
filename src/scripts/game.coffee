class connect4.Game extends Phaser.Game
  constructor: (element, logic) ->
    super window.innerWidth, window.innerHeight, Phaser.AUTO, element,
      preload: => @onPreload()
      create: => @onCreate()
      resize: => @onResize()
    @gameData =
      logic: logic
      finished: false
      ratio: 1
      offsets:
        grid: 90
        gridcolumn: 63
        disc: 255
        column: 256
      pos:
        x: 0
        y: 0

  discPut: (i, j, type, group='discs') ->
    x = @gameData.offsets.grid + @gameData.offsets.disc * i
    y = @gameData.offsets.grid + @gameData.offsets.disc * (5 - j)
    @gameData[group].create x, y, type

  reset: ->
    discs = @gameData.discs.children
    while discs.length isnt 0
      discs.pop().destroy()
    @gameData.finished = false
    return

  onPreload: ->
    @load.image 'grid', 'assets/images/grid.png'
    @load.image 'empty', 'assets/images/empty.png'
    @load.image 'p1', 'assets/images/player1.png'
    @load.image 'p2', 'assets/images/player2.png'
    @load.image 'column', 'assets/images/column.png'
    @load.image 'selected', 'assets/images/selected.png'
    @load.image 'pause', 'assets/images/pause.png'

  pauseState: -> @gameData.logic.pause()

  onCreate: ->
    @scale.scaleMode = Phaser.ScaleManager.RESIZE
    @stage.backgroundColor = '#87CEEB'

    @gameData.grid = @add.group()
    @gameData.grid.create 0, 0, 'grid'

    @gameData.buttons = @add.group()
      .add @add.button 10, 10, 'pause', @pauseState, this

    discsCreate = (j) =>
      @discPut i, j, 'empty', 'grid' for i in [0..6]
    discsCreate j for j in [0..5]
    @gameData.discs = @add.group()

    @gameData.selected = @add.group()
    @gameData.transp = @gameData.selected.create @columnPos(3), 50, 'selected'

    @gameData.columns = @add.group()
    @columnsCreate i for i in [0..6]

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
    groupScale @gameData.columns
    @scale.refresh()

  columnPos: (i) ->
    Math.ceil @gameData.offsets.gridcolumn + @gameData.offsets.column * i

  columnHover: (column) ->
    @gameData.transp.x = @columnPos(column.i)

  columnClicked: (column) ->
    return if @gameData.finished
    @gameData.finished = @gameData.logic.play column
    if @gameData.finished
      window.setTimeout =>
        @gameData.logic.stop()
      , 500

  columnsCreate: (i) ->
    x = @columnPos i
    button = @add.button x, 0, 'column', @columnClicked, this
    button.inputEnabled = true
    @gameData.columns.add button
    button.i = i
    over = (button, pointer) => @columnHover button, pointer
    button.events.onInputOver.add over, this

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
