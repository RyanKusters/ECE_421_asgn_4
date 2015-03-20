# the board representation. Essentially just a grid of pieces.
class Board
  def initialize(dims)
    @board = (0..dims[0]-1).collect { |i|
      (0..dims[1]-1).collect {0}
    }
  end

  # get the piece in a specific spot
  def [](x,y)
    begin
      return @board[x][y]
    rescue
      a = 1
    end

  end

  # put a piece in the given column. If the column is full, return false. Else,
  # return the row in which the piece was placed.
  def put(piece,column)
    firstEmpty = _firstEmptyRowOfColumn(column)
    if firstEmpty == nil
      return false
    end
    @board[firstEmpty][column] = piece
    return firstEmpty
  end

  # get the height of the board
  def getHeight
    return @board.length
  end

  # get the width of the board
  def getWidth
    return @board[0].length
  end

  # get the number of pieces in play
  def pieceCount
    return @board.collect {|i| i.select{|j| j != 0}.size}.inject{|sum,x| sum + x}
  end

  # return true if the board is full
  def full
    return !(0..@board[0].length-1).any? {|i| _firstEmptyRowOfColumn(i) != nil}
  end

  # return true if the given column is full
  # TODO: unit tests
  def columnFull(index)
    return _firstEmptyRowOfColumn(index) ? true : false
  end

  # get the first empty row in the given column, or nil if there is none
  def _firstEmptyRowOfColumn(col)
    revVal = @board.reverse.find_index {|i| i[col] == 0}
    if revVal == nil
      return nil
    end
    return @board.length - 1 - revVal
  end

end