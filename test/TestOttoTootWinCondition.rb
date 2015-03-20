require_relative '../src/model/OttoTootWinCondition'
require_relative '../src/model/Board'
require 'test/unit'

class TestOttoTootWinCondition < Test::Unit::TestCase

  def setup
    @T = 't'
    @o = 'o' # the players' pieces. picked X and o so that it is easier to see when there are many in a small space
    @winCondition = OttoTootWinCondition.new(@T,@o)
    @xSize = 7
    @ySize = 6
    @board = Board.new([@ySize,@xSize])
  end

  def teardown

  end

  # the first played piece cannot be a win
  def testBlank
    putPieces(@T)
    assert(!@winCondition.win(@board,@ySize-1,0))
  end

  # a full board with no rows of four is not a win
  def testFull
    putPieces(@T,@o,@T,@o,@T,@o,@T)
    putPieces(@o,@T,@o,@T,@o,@T,@o)
    putPieces(@T,@o,@T,@o,@T,@o,@T)
    putPieces(@o,@T,@o,@T,@o,@T,@o)
    putPieces(@T,@o,@T,@o,@T,@o,@T)
    putPieces(@o,@T,@o,@T,@o,@T,@o)
    assert(!@winCondition.win(@board,@ySize-1,0))
  end

  # a full board when the last piece placed is a win
  def testFullWin
    putPieces(@T,@o,@T,@o,@T,@o,@T)
    putPieces(@o,@T,@o,@T,@o,@T,@o)
    putPieces(@T,@o,@T,@o,@T,@o,@T)
    putPieces(@o,@T,@o,@T,@o,@T,@o)
    putPieces(@T,@o,@T,@o,@T,@o,@o)
    putPieces(@o,@T,@o,@T,@o,@T,@T)
    assert_equal(@winCondition.win(@board,0,@xSize-1),@T)
  end

  # four vertical of player 1 is a win for player 1
  def testP1WinVertical
    putPieces(@T)
    putPieces(@o)
    putPieces(@o)
    putPieces(@T)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@T)
  end

  # four vertical of player 2 is a win for player 2
  def testP2WinVertical
    putPieces(@o)
    putPieces(@T)
    putPieces(@T)
    putPieces(@o)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@o)
  end

  # four horizontal of player 1 is a win for player 1
  def testP1WinHorizontal
    putPieces(@T,@o,@o,@T)
    assert_equal(@winCondition.win(@board,@ySize-1,3),@T)
  end

  # four vertical of player 2 is a win for player 2
  def testP2WinHorizontal
    putPieces(@o,@T,@T,@o)
    assert_equal(@winCondition.win(@board,@ySize-1,3),@o)
  end

  # four diagonal of player 1 is a win for player 1
  def testP1WinDiagonal
    putPieces(@o,@o,@o,@T)
    putPieces(@o,@o,@o,@o)
    putPieces(@o,@o,@o,@o)
    putPieces(@T,@o,@o,@o)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@T)
  end

  # four diagonal of player 2 is a win for player 2
  def testP2WinDiagonal
    putPieces(@o,@o,@o,@o)
    putPieces(@o,@o,@T,@o)
    putPieces(@o,@T,@o,@o)
    putPieces(@o,@o,@o,@o)
    assert_equal(@winCondition.win(@board,@ySize-4,0),@o)
  end

  # convenience method for filling the board
  def putPieces(*args)
    (0..@xSize-1).each {|x|
      @board.put(args[x],x)
    }
  end

end