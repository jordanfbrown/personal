class Tetris.Tetrimino

  TYPES: ['I', 'J', 'L', 'O', 'S', 'T', 'Z']

  currentPosition: null

  board: null

  SQUARE_WIDTH: null

  currentColor: '#000'

  width: 4 # this will change

  constructor: (context, board) ->
    @context = context
    @board = board
    @SQUARE_WIDTH = @board.BOARD_WIDTH / 10
    @currentPosition = { x: @SQUARE_WIDTH * 3, y: 0 }
    @context.strokeStyle = @currentColor
    @moving = true
    @createSquares()
    @drawSquares()

  createSquares: ->
    @squares = ({ x: @SQUARE_WIDTH * 3 + @SQUARE_WIDTH * i, y: 0 } for i in [0..3])

  getBottomSquare: ->
    _.max @squares, (square) -> square.y

  getTopSquare: ->
    _.min @squares, (square) -> square.y

  getLeftSquare: ->
    _.min @squares, (square) -> square.x

  getRightSquare: ->
    _.max @squares, (square) -> square.x

  drawSquares: ->
    for square in @squares
      @drawSquare square

  deletePreviousSquare: (square) ->
    @context.clearRect square.x - 1, square.y - 1, @SQUARE_WIDTH + 2, @SQUARE_WIDTH + 2

  drawSquare: (square) ->
    @context.strokeRect square.x, square.y, @SQUARE_WIDTH, @SQUARE_WIDTH

  moveLeft: ->
    if @getLeftSquare().x > 0
      for square in @squares
        @deletePreviousSquare square
        square.x -= @SQUARE_WIDTH
      @drawSquares()

  moveRight: ->
    if @getRightSquare().x + @SQUARE_WIDTH < @board.BOARD_WIDTH
      for square in @squares
        @deletePreviousSquare square
        square.x += @SQUARE_WIDTH
      @drawSquares()

  softDrop: ->
    if @getBottomSquare().y + @SQUARE_WIDTH < @board.BOARD_HEIGHT
      for square in @squares
        @deletePreviousSquare square
        square.y += @SQUARE_WIDTH
      @drawSquares()

  rotate: ->
    console.log 'rotate'

  fastDrop: ->
    console.log 'fast drop'

  update: ->
    if @getBottomSquare().y + @SQUARE_WIDTH >= @board.BOARD_HEIGHT
      @moving = false
      for square in @squares
        @board.addOccupiedSpace square.x / @SQUARE_WIDTH, square.y / @SQUARE_WIDTH
    else
      for square in @squares
        @deletePreviousSquare square
        square.y += @SQUARE_WIDTH
      @drawSquares()

  isMoving: ->
    @moving


