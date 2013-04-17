class Tetris.Board

  BOARD_WIDTH: 300

  BOARD_HEIGHT: 540

  currentTetrimino: null

  SPEED: 750

  constructor: ->
    @initializeCanvas()
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
      @generateTetrimino() if @currentTetrimino.stoppedMoving()
    , @SPEED

  generateTetrimino: ->
    @currentTetrimino = new Tetris.Tetrimino @context, @





