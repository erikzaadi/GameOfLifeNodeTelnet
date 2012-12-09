telnet = require 'wez-telnet' 
gol = require './gameoflife'
new telnet.Server (client) ->
  client.running = false
  client.write "\u001B[2J"
  client.write "\u001B[0;0H"
  client.write """Helloz!
  
  Welcome to The Game Of Life!


  Hacked together at Global Coderetreat 2012 (Tel Aviv).
  See source at https://github.com/erikzaadi/GameOfLifeNodeTelnet


  Press enter to start.."""

  client.on 'data', (data) ->
    if !client.running
      client.running = true
      client.game = new gol(client.windowSize[0], client.windowSize[1])
      client.game.start (board) =>
        if client.writable
          client.write "\u001B[2J\u001B[32m#{board}\u001B[0m"   
        else
          client.game.stop()
      , 300

  console.log "connected term=%s %dx%d" , 
    client.term, client.windowSize[0], client.windowSize[1]

  client.on 'resize', (width, height) =>
    console.log "resize #{width} #{height}"
    if client.running
      client.game.resize(width, height)
    
  client.on 'interrupt', ->
    console.log "INTR!"
    # disconnect on CTRL-C!
    client.end()

  client.on 'close', ->
    console.log "END!"

.listen 1337
