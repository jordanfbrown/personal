class Tetris.Tetrimino

  TYPES: [
    { letter: 'I', color: 'red', },
    { letter: 'J', color: 'blue', },
    { letter: 'L', color: 'orange', },
    { letter: 'O', color: 'purple', },
    { letter: 'S', color: 'magenta', },
    { letter: 'T', color: 'cyan', },
    { letter: 'Z', color: 'green', }
  ]

  board: null

  SQUARE_WIDTH: null

  strokeStyle: '#000'

  fillStyle: '#000'

  constructor: (context, board) ->
    @context = context
    @board = board
    @SQUARE_WIDTH = @board.BOARD_WIDTH / @board.NUM_ROWS
    @moving = true
    @type = @TYPES[Math.floor Math.random() * 7]
    
    @createSquares()
    @drawSquares()

  createSquares: ->
    switch @type.letter
      when 'I'
        @squares = ({ x: @SQUARE_WIDTH * 3 + @SQUARE_WIDTH * i, y: 0 } for i in [0..3])
      when 'J'
        @squares = [
          { x: @SQUARE_WIDTH * 3, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 5, y: 0 }
          { x: @SQUARE_WIDTH * 5, y: @SQUARE_WIDTH }
        ]
      when 'L'
        @squares = [
          { x: @SQUARE_WIDTH * 3, y: @SQUARE_WIDTH }
          { x: @SQUARE_WIDTH * 3, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 5, y: 0 }
        ]
      when 'O'
        @squares = [
          { x: @SQUARE_WIDTH * 3, y: 0 }
          { x: @SQUARE_WIDTH * 3, y: @SQUARE_WIDTH }
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: @SQUARE_WIDTH }
        ]
      when 'S'
        @squares = [
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 5, y: 0 }
          { x: @SQUARE_WIDTH * 3, y: @SQUARE_WIDTH }
          { x: @SQUARE_WIDTH * 4, y: @SQUARE_WIDTH }
        ]
      when 'T'
        @squares = [
          { x: @SQUARE_WIDTH * 3, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 5, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: @SQUARE_WIDTH }
        ]
      when 'Z'
        @squares = [
          { x: @SQUARE_WIDTH * 3, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: 0 }
          { x: @SQUARE_WIDTH * 4, y: @SQUARE_WIDTH }
          { x: @SQUARE_WIDTH * 5, y: @SQUARE_WIDTH }
        ]

    @context.strokeStyle = @strokeStyle
    @context.fillStyle = @type.color

  drawSquares: ->
    for square in @squares
      @drawSquare square

  deletePreviousSquare: (square) ->
    @context.strokeStyle = '#fff'
    @context.clearRect square.x, square.y, @SQUARE_WIDTH, @SQUARE_WIDTH

  drawSquare: (square) ->
    @context.strokeStyle = @strokeStyle
#    @context.strokeRect square.x, square.y, @SQUARE_WIDTH, @SQUARE_WIDTH
    @context.fillRect square.x, square.y, @SQUARE_WIDTH, @SQUARE_WIDTH

  moveLeft: ->
    if @canMoveLeft()
      for square in @squares
        @deletePreviousSquare square
        square.x -= @SQUARE_WIDTH
      @drawSquares()

  moveRight: ->
    if @canMoveRight()
      for square in @squares
        @deletePreviousSquare square
        square.x += @SQUARE_WIDTH
      @drawSquares()

  softDrop: ->
    if @canMoveDown()
      for square in @squares
        @deletePreviousSquare square
        square.y += @SQUARE_WIDTH
      @drawSquares()

  rotate: ->
    console.log 'rotate'

  fastDrop: ->
    console.log 'fast drop'

  update: ->
    if @canMoveDown()
      for square in @squares
        @deletePreviousSquare square
        square.y += @SQUARE_WIDTH
      @drawSquares()
    else
      @moving = false
      for square in @squares
        @board.addOccupiedSpace square.x / @SQUARE_WIDTH, square.y / @SQUARE_WIDTH

  canMoveDown: ->
    _.all @squares, (square) =>
      column = (square.y + @SQUARE_WIDTH) / @SQUARE_WIDTH
      row = square.x / @SQUARE_WIDTH
      square.y + @SQUARE_WIDTH < @board.BOARD_HEIGHT && !@board.isSpaceTaken row, column

  canMoveLeft: ->
    _.all @squares, (square) =>
      column = square.y / @SQUARE_WIDTH
      row = (square.x - @SQUARE_WIDTH) / @SQUARE_WIDTH
      square.x > 0 && !@board.isSpaceTaken row, column

  canMoveRight: ->
    _.all @squares, (square) =>
      column = square.y / @SQUARE_WIDTH
      row = (square.x + @SQUARE_WIDTH) / @SQUARE_WIDTH
      square.x + @SQUARE_WIDTH < @board.BOARD_WIDTH && !@board.isSpaceTaken row, column

  isMoving: ->
    @moving


