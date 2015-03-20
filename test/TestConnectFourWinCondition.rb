require_relative '../src/model/ConnectFourWinCondition'
require_relative '../src/model/Board'
require 'test/unit'

class TestConnectFourWinCondition < Test::Unit::TestCase

  def setup
    @X = '1'
    @o = '2' # the players' pieces. picked X and o so that it is easier to see when there are many in a small space
    @winCondition = ConnectFourWinCondition.new
    @xSize = 7
    @ySize = 6
    @board = Board.new([@ySize,@xSize])
  end

  def teardown

  end

  # the first played piece cannot be a win
  def testBlank
    putPieces(@X)
    assert(!@winCondition.win(@board,@ySize-1,0))
  end

  # a full board with no rows of four is not a win
  def testFull
    putPieces(@X,@X,@X,@o,@o,@o,@X)
    putPieces(@o,@o,@o,@X,@X,@X,@o)
    putPieces(@X,@X,@X,@o,@o,@o,@X)
    putPieces(@o,@o,@o,@X,@X,@X,@o)
    putPieces(@X,@X,@X,@o,@o,@o,@X)
    putPieces(@o,@o,@o,@X,@X,@X,@O)
    assert(!@winCondition.win(@board,@ySize-1,0))
  end

  # a full board when the last piece placed is a win
  def testFullWin
    putPieces(@X,@X,@X,@o,@o,@o,@X)
    putPieces(@o,@o,@o,@X,@X,@o,@X)
    putPieces(@X,@X,@X,@o,@X,@o,@o)
    putPieces(@o,@o,@o,@X,@X,@X,@o)
    putPieces(@X,@X,@X,@o,@o,@X,@o)
    putPieces(@o,@o,@o,@X,@X,@X,@o)
    assert_equal(@winCondition.win(@board,0,@xSize-1),@o)
  end

  # four vertical of player 1 is a win for player 1
  def testP1WinVertical
    putPieces(@X)
    putPieces(@X)
    putPieces(@X)
    putPieces(@X)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@X)
  end

  # four vertical of player 2 is a win for player 2
  def testP2WinVertical
    putPieces(@o)
    putPieces(@o)
    putPieces(@o)
    putPieces(@o)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@o)
  end

  # four horizontal of player 1 is a win for player 1
  def testP1WinHorizontal
    putPieces(@X,@X,@X,@X)
    assert_equal(@winCondition.win(@board,@ySize-1,3),@X)
  end

  # four vertical of player 2 is a win for player 2
  def testP2WinHorizontal
    putPieces(@o,@o,@o,@o)
    assert_equal(@winCondition.win(@board,@ySize-1,3),@o)
  end

  # four diagonal of player 1 is a win for player 1
  def testP1WinDiagonal
    putPieces(@o,@o,@o,@X)
    putPieces(@o,@o,@X,@o)
    putPieces(@o,@X,@o,@o)
    putPieces(@X,@o,@o,@o)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@X)
  end

  # four diagonal of player 2 is a win for player 2
  def testP2WinDiagonal
    putPieces(@X,@X,@X,@o)
    putPieces(@X,@X,@o,@X)
    putPieces(@X,@o,@X,@X)
    putPieces(@o,@X,@X,@X)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@o)
  end

  # convenience method for filling the board
  def putPieces(*args)
    (0..@xSize-1).each {|x|
      @board.put(args[x],x)
    }
  end

end