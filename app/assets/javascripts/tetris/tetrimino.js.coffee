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

  squareWidth: null

  strokeStyle: '#000'

  fillStyle: '#000'

  ROTATION_ANGLE: Math.PI / 2

  constructor: (context, board) ->
    @context = context
    @board = board
    @squareWidth = @board.BOARD_HEIGHT / @board.NUM_ROWS
    @moving = true
    @rotationState = 0
#    @type = @TYPES[Math.floor Math.random() * 7]
    @type = @TYPES[0]

    @buildMatrices()
    @createSquares()
    @drawSquares()

  buildMatrices: ->
    @rotationMatrix = [
      [ 0, 1 ]
      [ -1,  0 ]
    ]

  createSquares: ->
    switch @type.letter
      when 'I'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 5, y: 0 }
          { x: @squareWidth * 6, y: 0 }
        ]
      when 'J'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 5, y: 0 }
          { x: @squareWidth * 5, y: @squareWidth }
        ]
      when 'L'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 5, y: 0 }
          { x: @squareWidth * 3, y: @squareWidth }
        ]
      when 'O'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 3, y: @squareWidth }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 4, y: @squareWidth }
        ]
      when 'S'
        @squares = [
          { x: @squareWidth * 5, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 3, y: @squareWidth }
          { x: @squareWidth * 4, y: @squareWidth }
        ]
      when 'T'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 5, y: 0 }
          { x: @squareWidth * 4, y: @squareWidth }
        ]
      when 'Z'
        @squares = [
          { x: @squareWidth * 3, y: 0 }
          { x: @squareWidth * 4, y: 0 }
          { x: @squareWidth * 4, y: @squareWidth }
          { x: @squareWidth * 5, y: @squareWidth }
        ]

    @context.strokeStyle = @strokeStyle
    @context.fillStyle = @type.color

  drawSquares: ->
    for square in @squares
      @drawSquare square

  deletePreviousSquare: (square) ->
    @context.strokeStyle = '#fff'
    @context.clearRect square.x, square.y, @squareWidth, @squareWidth

  drawSquare: (square) ->
    @context.strokeStyle = @strokeStyle
#    @context.strokeRect square.x, square.y, @squareWidth, @squareWidth
    @context.fillRect square.x, square.y, @squareWidth, @squareWidth

  moveLeft: ->
    if @canMoveLeft()
      for square in @squares
        @deletePreviousSquare square
        square.x -= @squareWidth
      @drawSquares()

  moveRight: ->
    if @canMoveRight()
      for square in @squares
        @deletePreviousSquare square
        square.x += @squareWidth
      @drawSquares()

  getBottomSquares: ->
    maxY = (_.max @squares, (square) -> square.y).y
    (square for square in @squares when square.y == maxY)

  rotate: ->
    unless @type.letter == 'O'
      rotateAround = _.clone @squares[1]
      for square in @squares
        @deletePreviousSquare square
        rotated = @rotateSquare square, rotateAround
        square.x = rotated.x
        square.y = rotated.y
      @drawSquares

  rotateSquare: (square, around) ->
    x = square.x - around.x
    y = square.y - around.y
    [x, y] = [y, -x]
    { x: x + around.x, y: y + around.y }

  softDrop: ->
    if @canMoveDown()
      for square in @squares
        @deletePreviousSquare square
        square.y += @squareWidth
      @drawSquares()

  fastDrop: ->
    columns = (square.x / @squareWidth for square in @squares)
    highestSpace = @board.findHighestSpace columns
    grouped = _.groupBy @squares, (square) -> square.y
    numGroups = _.size grouped
    groupCount = 0
    for y, groups of grouped
      for square in groups
        @deletePreviousSquare square
        if _.size(highestSpace) > 0
          square.y = highestSpace.row * @squareWidth - @squareWidth * (numGroups - groupCount)
        else
          square.y = @board.BOARD_HEIGHT - @squareWidth * (numGroups - groupCount)
      groupCount += 1
    @drawSquares()

  debugSquares: ->
    for square in @squares
      console.log square

  update: ->
    if @canMoveDown()
      for square in @squares
        @deletePreviousSquare square
        square.y += @squareWidth
      @drawSquares()
    else
      @moving = false
      for square in @squares
        @board.addOccupiedSpace square.y / @squareWidth, square.x / @squareWidth

  canMoveDown: ->
    _.all @squares, (square) =>
      row = (square.y + @squareWidth) / @squareWidth
      column = square.x / @squareWidth
      square.y + @squareWidth < @board.BOARD_HEIGHT && !@board.isSpaceTaken row, column

  canMoveLeft: ->
    _.all @squares, (square) =>
      row = square.y / @squareWidth
      column = (square.x - @squareWidth) / @squareWidth
      square.x > 0 && !@board.isSpaceTaken row, column

  canMoveRight: ->
    _.all @squares, (square) =>
      row = square.y / @squareWidth
      column = (square.x + @squareWidth) / @squareWidth
      square.x + @squareWidth < @board.BOARD_WIDTH && !@board.isSpaceTaken row, column

  isMoving: ->
    @moving


