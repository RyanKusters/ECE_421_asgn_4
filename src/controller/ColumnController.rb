class ColumnController

  def initialize(game)
    @game = game
  end

  # place a piece in the game, at the column of the given index. If isAI
  # is true, then the AI played the piece. Otherwise, a human did.
  def clickColumn(index)
    @game.placePiece(index)
  end

end