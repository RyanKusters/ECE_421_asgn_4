require_relative '../src/model/Board'
require 'test/unit'

class TestBoard < Test::Unit::TestCase
  def setup
    @pieceType1 = '1'
    @pieceType2 = '2'
    @xSize = 7
    @ySize = 6
    @board = Board.new([@ySize,@xSize])
  end

  def teardown

  end

  # test that the put function places a piece at the bottom of an empty column
  def testPutEmpty
    assert_equal(@board[-1,0], 0, 'board did not start empty')
    ret = @board.put(@pieceType1,0)
    assert_equal(@board[-1,0], @pieceType1, 'correct piece was not placed')
    assert(ret)
  end

  # test that the put function places a piece on top of the bottom piece in a non-empty column
  def testPutNonEmpty
    ret1 = @board.put(@pieceType1,0)
    assert_equal(@board[-2,0], 0, 'correct piece was not placed')
    assert(ret1, 'wrong return value')
    ret2 = @board.put(@pieceType2,0)
    assert_equal(@board[-1,0], @pieceType1, 'bottom piece changed')
    assert_equal(@board[-2,0], @pieceType2, 'piece was not placed correctly')
    assert(ret2, 'wrong return value')
  end

  # test that the function returns false when a column is full, and does not alter the column
  def testPutFull
    (0..@ySize-1).each {
        @board.put(@pieceType1,0)
    }
    ret = @board.put(@pieceType2,0)
    assert(!ret, 'wrong return value')
    (0..@ySize-1).each { |i|
      assert_equal(@board[i,0], @pieceType1, 'piece changed')
    }
  end

  # test that firstemptyrowofcolumn is the length of the column-1 if the column is empty
  def testFirstEmpty
    assert_equal(@ySize-1, @board._firstEmptyRowOfColumn(0), 'wrong index returned for bottom of column')
  end

  # test that firstemptyrowofcolumn is correct if the column is not empty
  def testFirstNotEmpty
    @board.put(@pieceType1,0)
    assert_equal(@ySize-2, @board._firstEmptyRowOfColumn(0), 'wrong index returned for bottom of column')
  end

  # test that firstemptyrowofcolumn returns nil if the column is full
  def testFirstFull
    (0..@ySize-1).each {
      @board.put(@pieceType1,0)
    }
    assert_nil(@board._firstEmptyRowOfColumn(0), 'did not return nil when there are no more open cells in the column')
  end

  # test that the full function returns true when the board is full
  def testBoardFull
    (0..@xSize-1).each {|x|
      (0..@ySize-1).each {|y|
        assert(!@board.full)
        @board.put(@pieceType1,x)
      }
    }
    assert(@board.full)
  end
end