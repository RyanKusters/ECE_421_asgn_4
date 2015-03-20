require_relative 'Board'

# overall state of the game
class Game

  def Game.CHANGE_TURN_FLAG
    'CHANGE_TURN'
  end
  def Game.WIN_FLAG
    'WIN'
  end
  def Game.STALEMATE_FLAG
    'STALEMATE'
  end
  def Game.COLUMN_FULL_FLAG
    'COLUMN_FULL'
  end

  def initialize(pieces, winCondition, dimensions)
    @pieces = pieces
    @players = pieces.keys
    @playerIndex = 0
    @winCondition = winCondition
    @board = Board.new(dimensions)
    @observers = []
  end

  def board
    return @board
  end

  # add an observer for when the state of the game changes
  def addObserver(observer)
    @observers << observer
  end

  # get the player whose turn it currently is
  def turn
    return @players[@playerIndex]
  end

  # place a piece in the given column
  def placePiece(column)
    newPieceRow = @board.put(@pieces[turn],column)
    if newPieceRow
      _changeTurn
      _notifyObservers(Game.CHANGE_TURN_FLAG,@board,turn)
      win = @winCondition.win(@board,newPieceRow,column)
      if win
        _notifyObservers(Game.WIN_FLAG,win)
      elsif @board.full
        _notifyObservers(Game.STALEMATE_FLAG)
      end
    else
      _notifyObservers(Game.COLUMN_FULL_FLAG)
    end
  end

  def _changeTurn
    @playerIndex += 1
    if @playerIndex >= @players.length
      @playerIndex = 0
    end
  end

  def _notifyObservers(*args)
    @observers.each {|o| o.notify(args)}
  end

end