require_relative 'OttoTootWinCondition'
require_relative 'ConnectFourWinCondition'

class GameFactory

  # create and return a game object.
  # game type is the name of the game (either "CONNECT_FOUR" (ConnectFour.name) or "OTTO_TOOT" (OttoToot.name))
  # playerNAI is false if the player is not an AI, or 1 2 or 3 for the difficulty levels
  # playerNPiece is the piece object for the given player
  # dimensions is an array of the number of rows and columns in the game board
  def createGame(gameType, player1AI, player2AI, player1Piece, player2Piece, dimensions)
    pieces = Hash.new
    pieces[1] = player1Piece
    pieces[2] = player2Piece
    ai1 = false
    ai2 = false
    if player1AI
      if player1AI == 1
        ai1 = 1
      elsif player1AI == 2
        ai1 = 2
      elsif player1AI == 3
        ai1 = 3
      end
    end
    if player2AI
      if player2AI == 1
        ai2 = 1
      elsif player2AI == 2
        ai2 = 2
      elsif player2AI == 3
        ai2 = 3
      end
    end
    if gameType == OttoTootWinCondition.name
      winCondition = OttoTootWinCondition.new(player1Piece,player2Piece)
    elsif gameType == ConnectFourWinCondition.name
      winCondition = ConnectFourWinCondition.new(player1Piece,player2Piece)
    end

    game = Game.new(pieces,winCondition,dimensions)

    # make sure the ais know what's going on in the game
    if ai1
      game.addObserver(ai1)
    end
    if ai2
      game.addObserver(ai2)
    end

    return game

  end
end