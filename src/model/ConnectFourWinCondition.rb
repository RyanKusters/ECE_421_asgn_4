class ConnectFourWinCondition

  def ConnectFourWinCondition.name
    'CONNECT_FOUR'
  end

  # if the win condition has been met, return false. Otherwise, return the user
  # who wins.
  # input:
  #   board: the state of the game
  #   row: the row where the newest piece was placed
  #   col: the column where the newest piece was placed
  def win(board,row,col)
    operations = [[:+,nil],[nil,:+],[:+,:+],[:+,:-]] # the four directions to win
    anyWin = operations.any? {|i|
      _axisWin(board,row,col,i[0],i[1])
    }
    if anyWin
      return board[row,col]
    end
    return false

  end

  # check if the given value is inbounds or not. True for row, and false for column
  def _inbounds(val,rowCol,board)
    if rowCol
      return (val >=0 and val < board.getWidth)
    end
    return (val >= 0 and val < board.getHeight)
  end

  # do the work for _axisWin along side of the given space. Reverse operation
  # should be either :+ or :-, and indicates which side we are checking
  def _countOneWay(board,row,col,horizontalOperation,verticalOperation,reverseOperation)
    num = (1..3).find_index{ |i|
      x = horizontalOperation == nil ? col : col.send(reverseOperation, 0.send(horizontalOperation,i))
      y = verticalOperation == nil ? row : row.send(reverseOperation, 0.send(verticalOperation,i))
      !_inbounds(x,true,board) or
          !_inbounds(y,false,board) or
          board[y,x] != board[row,col]
    }
    if num == nil # meaning they were all good
      num = 3
    end
    return num
  end

  # see if the win condition is met on the given axis (vertical, horizontal,
  # or one of the two diagonals). HorizontalOperation and verticalOperation
  # should be either :+, :-, or nil, indicating what way will check on the axes.
  # A line will be checked with a slope equal to horizontalOperation/verticalOperation
  # (where nil is 0, + is one, and - is -1)
  # For example, if horizontal is + and vertical is nil, we will check the
  # horizontal axis. If horizontal is + and vertical is -, we will check a
  # diagonal going down and right.
  def _axisWin(board,row,col,horizontalOperation,verticalOperation)
    if 1 + _countOneWay(board,row,col,horizontalOperation,verticalOperation,:+) + _countOneWay(board,row,col,horizontalOperation,verticalOperation,:-) >= 4
      return board[row,col]
    end
    return false
  end

end