class Tetris.Tetrimino

  TYPES: ['I', 'J', 'L', 'O', 'S', 'T', 'Z']

  currentPosition: null

  currentColor: '#000'

  constructor: (context, board) ->
    @context = context
    @board = board
    @SQUARE_WIDTH = @board.BOARD_WIDTH / 10
    @currentPosition = { x: @SQUARE_WIDTH * 3, y: 0 }

    @draw()

  draw: ->
    @context.strokeStyle = @currentColor
    for i in [0..3]
      @context.strokeRect(@currentPosition.x + i * @SQUARE_WIDTH, @currentPosition.y, @SQUARE_WIDTH, @SQUARE_WIDTH)
    if @currentPosition.y > 0
      for i in [0..3]
        @context.clearRect(@currentPosition.x - 1 + i * @SQUARE_WIDTH, @currentPosition.y - @SQUARE_WIDTH, @SQUARE_WIDTH + 2, @SQUARE_WIDTH)

  moveLeft: ->
    console.log 'left'

  moveRight: ->
    console.log 'right'
    
  softDrop: ->
    console.log 'soft drop'

  rotate: ->
    console.log 'rotate'

  fastDrop: ->
    console.log 'fast drop'

  update: ->
    @currentPosition.y += @SQUARE_WIDTH
    @draw()

  stoppedMoving: ->
    false


