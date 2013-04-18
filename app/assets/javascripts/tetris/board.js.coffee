class Tetris.Board

  BOARD_WIDTH: 300

  BOARD_HEIGHT: 540

  NUM_ROWS: 10

  NUM_COLUMNS: 18

  SPEED: 450
  
  currentTetrimino: null

  occupiedSpaces: []

  constructor: ->
    @initializeCanvas()
    @initializeOccupiedSpaces()
    @bindEvents()
    @run()

  initializeCanvas: ->
    @canvas = document.getElementById 'tetris'
    @canvas.style.width = @BOARD_WIDTH + 'px'
    @canvas.style.height = @BOARD_HEIGHT + 'px'
    @canvas.setAttribute 'height', @BOARD_HEIGHT + 'px'
    @canvas.setAttribute 'width', @BOARD_WIDTH + 'px'

    @context = @canvas.getContext '2d'

    window.ctx = @context

  initializeOccupiedSpaces: ->
    for i in [0..@NUM_ROWS - 1]
      @occupiedSpaces[i] = []
      for j in [0..@NUM_COLUMNS - 1]
        @occupiedSpaces[i][j] = false

  addOccupiedSpace: (row, col) ->
    @occupiedSpaces[row][col] = true

  isSpaceTaken: (row, col) ->
    @occupiedSpaces[row][col] == true

  bindEvents: ->
    document.addEventListener 'keydown', @handleKeyPress
    
  handleKeyPress: (event) =>
    switch event.which
      when 37 then @currentTetrimino.moveLeft() # Left arrow
      when 39 then @currentTetrimino.moveRight() # Right arrow
      when 40 then @currentTetrimino.softDrop() # Down arrow
      when 38 then @currentTetrimino.rotate() # Up arrow
      when 32 then @currentTetrimino.fastDrop() # Space bar

  run: ->
    @generateTetrimino()
    setInterval =>
      @currentTetrimino.update()
      @generateTetrimino() unless @currentTetrimino.isMoving()
    , @SPEED

  generateTetrimino: ->
    @currentTetrimino = new Tetris.Tetrimino @context, @







