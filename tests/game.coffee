require('chai').should() 
gol = require '../gameoflife'

count = (string, substr) ->
  num = pos = 0
  return 1/0 unless substr.length
  num++ while pos = 1 + string.indexOf substr, pos
  num

getAlives = (game) ->
    alives = 0
    for row in [0..game.width]
      for col in [0..game.height]
        ++alives if game.isAlive row, col
    alives


knownFormations =
  tetrisSwitcher:  
    origin: [(x:3, y:7), (x:3, y:8), (x:3, y:9)]
    to:[(x:2, y:8), (x:3, y:8), (x:4, y:8)]
  block:
    origin: [(x:1, y:7), (x:1, y:8), (x:2, y:7), (x:2, y:8)]
    to: [(x:1, y:7), (x:1, y:8), (x:2, y:7), (x:2, y:8)]


describe 'Constructor', ->  
  it 'should initialize board', ->  
    game1 = new gol(22, 12)
    game1.height.should.equal 12
    game1.width.should.equal 22
    game1.board.length.should.equal 22
    game1.board[0].length.should.equal 12

  it 'should add random cells', ->
    game1 = new gol(22, 12)
    getAlives(game1).should.be.at.least 1

  it 'should be able to get explicit alive cells', ->
    game1 = new gol(22, 12, [(x:1, y:7), (x:2, y:8)])

    game1.isAlive(1, 7).should.be.true
    game1.isAlive(2, 8).should.be.true
    game1.isAlive(2, 9).should.be.false

describe 'Evolve', ->
  it 'should stay the same for block', ->
    game1 = new gol(22, 12, knownFormations.block.origin)

    getAlives(game1).should.be.equal knownFormations.block.origin.length

    game1.evolve()

    for coord in knownFormations.block.to
      game1.isAlive(coord.x, coord.y).should.be.true

    getAlives(game1).should.be.equal knownFormations.block.origin.length

  it 'should evolve correctly for tetris madness', ->
    game1 = new gol(22, 12, knownFormations.tetrisSwitcher.origin)

    getAlives(game1).should.be.equal knownFormations.tetrisSwitcher.origin.length

    game1.evolve()

    for coord in knownFormations.tetrisSwitcher.to
      game1.isAlive(coord.x, coord.y).should.be.true

    getAlives(game1).should.be.equal knownFormations.tetrisSwitcher.origin.length

  it 'should kill a single cell', ->
    game1 = new gol(22, 12, [(x:1, y:7)])
    game1.evolve()
    getAlives(game1).should.be.zero
 
  it 'should kill two adjacant cells', ->
    game1 = new gol(22, 12, [(x:1, y:7), (x:2, y:7)])
    game1.evolve()
    getAlives(game1).should.be.zero
 
describe 'Print', ->
  it 'should print correct number of cells for tetris', ->
    game1 = new gol(22, 12, knownFormations.tetrisSwitcher.origin)
    count(game1.print(), game1.aliveChar).should.be.equal knownFormations.tetrisSwitcher.to.length

  it 'should print correct number of cells for block', ->
    game1 = new gol(22, 12, knownFormations.block.origin)
    count(game1.print(), game1.aliveChar).should.be.equal knownFormations.block.to.length
