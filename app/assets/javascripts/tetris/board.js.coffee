class Tetris.Board

  BOARD_WIDTH: 300

  BOARD_HEIGHT: 540

  NUM_ROWS: 18

  NUM_COLUMNS: 10

  SPEED: 450
  
  currentTetrimino: null

  occupiedSpaces: []

  constructor: ->
    @score = 0

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

  checkForLines: ->
    lines = []
    for i in [0..@NUM_ROWS - 1]
      valid = true
      for j in [0..@NUM_COLUMNS - 1]
        valid = valid && @occupiedSpaces[i][j]
      lines.push(i) if valid

    if lines.length > 0
      @clearLines lines
    
  clearLines: (rows) ->
    @updateScore rows.length
    @context.strokeStyle = '#fff'
    for row in rows
      for col in [0..@NUM_COLUMNS - 1]
        console.log row, col
        @occupiedSpaces[row][col] = false
        @context.clearRect col * 30, row * 30, 30, 30

  updateScore: (numLines) ->
    @score += numLines * 100
    console.log @score

  findHighestSpace: (columns) ->
    highest = Infinity
    cell = {}
    for row in [0..@NUM_ROWS - 1]
      for column in columns
        if row < highest && @occupiedSpaces[row][column]
          highest = row
          cell = { row: row, column: column }
    cell

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
      unless @currentTetrimino.isMoving()
        @checkForLines()
        @generateTetrimino()
    , @SPEED

  generateTetrimino: ->
    @currentTetrimino = new Tetris.Tetrimino @context, @







