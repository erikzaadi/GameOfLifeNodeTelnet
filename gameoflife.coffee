class GameOfLife
  aliveChar: "✩" #"₪" #"✡" #"✦" #"✺" #"◈" #"✩" #"✱" #"▣" #"█" 
  deadChar: " "  

  constructor: (@width, @height, initial=false) ->
    @board = @createBoard()
    if initial
      @populateBoard(initial)
    else
      @setRandomPoints()

  setRandomPoints: ->
    for row in [0...@width]
      for col in [0...@height]
        @board[row][col] = Math.round(Math.random())

  start: (printCallback, interval) ->
   @intervalId = setInterval (=>
      printCallback.call this, @print()
      @evolve()
   ), interval
 
  stop: ->
    clearInterval @intervalId if @intervalId

  evolve: () ->
    nextBoard = @createBoard()
    for row in [0...@width]
      for col in [0...@height]
        n = @countNeighbours row, col
        alive = @isAlive row, col
        if alive or n is 3
          nextBoard[row][col] = if 1 < n < 4 then 1 else 0

    @board = nextBoard

  createBoard: ->
    for row in [0...@width]
      for col in [0...@height]
        0 

  populateBoard: (initial) ->
    for cell in initial
      @board[cell.x][cell.y] = 1

  isAlive: (row, col) ->
    @board[row]?[col] == 1

  countNeighbours : (row, col) ->
    neighbours = 0
    for row_index in [-1..1]
      for col_index in [-1..1] when (row_index or col_index) and @isAlive row + row_index, col + col_index
        ++neighbours
    neighbours

  print: ->
    str = []
    for col in [0...@height]
      for row in [0...@width]
        str.push if @isAlive row, col then @aliveChar else @deadChar
      str.push "\n"
    str.join("")

  resize: (width, height) ->
    #if larger, generate some random cells in the new area?
    @width = width
    @height = height
    
module.exports = GameOfLife
