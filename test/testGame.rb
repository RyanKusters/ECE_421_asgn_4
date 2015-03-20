require_relative '../src/model/Game'
require_relative 'MockPiece'
require_relative 'MockWinCondition'
require_relative 'MockObserver'
require 'test/unit'

class TestGame < Test::Unit::TestCase

  def setup
    @player1 = 0
    @player2 = 1
    pieces = Hash.new
    @player1Piece = MockPiece.new('x')
    @player2Piece = MockPiece.new('y')
    pieces[@player1] = @player1Piece
    pieces[@player2] = @player2Piece
    @winCondition = MockWinCondition.new
    @xSize = 7
    @ySize = 6
    @game = Game.new(pieces,@winCondition,[@ySize,@xSize])
    @observer = MockObserver.new
    @game.addObserver(@observer)
  end

  def teardown

  end

  # test the base "Place" functionality: on a blank board
  def testPlaceNew
    assert_equal(@game.board.pieceCount,0,"game does not start with zero pieces.")
    @game.placePiece(0)
    assert_equal(@game.board.pieceCount,1,"new game piece not added")
    assert_equal(@game.board[-1,0], @player1Piece, "correct piece not added in the correct spot")
    @game.placePiece(2)
    assert_equal(@game.board.pieceCount,2,"new game piece not added")
    assert_equal(@game.board[-1,2], @player2Piece, "correct piece not added in the correct spot")
  end

  # test that the "Place" function stacks tiles when more than one are added in the same column
  def testPlaceStack
    @game.placePiece(0)
    assert_equal(@game.board.pieceCount,1,"new game piece not added")
    assert_equal(@game.board[-1,0], @player1Piece, "correct piece not added in the correct spot")
    @game.placePiece(0)
    assert_equal(@game.board.pieceCount,2,"new game piece not added")
    assert_equal(@game.board[-2,0], @player2Piece, "correct piece not added in the correct spot")
    @game.placePiece(0)
    assert_equal(@game.board.pieceCount,3,"new game piece not added")
    assert_equal(@game.board[-3,0], @player1Piece, "correct piece not added in the correct spot")
  end

  # test that if a piece is placed on a full column, the turn remains the same, and a notification is sent
  def testPlaceFull
    (0..@ySize-1).each {@game.placePiece(0)}
    currentTurn = @game.turn
    @game.placePiece(0)
    assert_equal(@game.board.pieceCount,@ySize,'piece played when column was full')
    assert_equal(@game.turn,currentTurn,'turn changed when playing on a full column')
    assert_equal(@observer.lastNotification[0], Game.COLUMN_FULL_FLAG, 'column full notification not sent')
  end

  # test that if the board is full, a stalemate notification is sent
  def testStalemate
    (0..@xSize-1).each {|x|
      (0..@ySize-1).each {|y|
        @game.placePiece(x)
      }
    }
    assert_equal(@observer.lastNotification[0], Game.STALEMATE_FLAG, 'stalemate notification not sent')
  end

  # ensure that observers all called when a piece is played
  def testPlaceObserver
    @game.placePiece(0)
    assert_equal(@observer.lastNotification[0], Game.CHANGE_TURN_FLAG, 'change turn notification not sent')
    assert_equal(@observer.lastNotification[1], @game.board, 'correct board not sent in notification')
    assert_equal(@observer.lastNotification[2], @player2, 'correct player not sent in notification')
  end

  # ensure that when the win condition is met, the correct notification is sent (including both the last piece that was
  # placed, as well as the win condition)
  def testWin
    @winCondition.setWin(@player1)
    @game.placePiece(0)
    assert_equal(@observer.notifications[-2][1], @game.board, 'correct board not sent in notification')
    assert_equal(@observer.notifications[-1][0], Game.WIN_FLAG, 'win condition not sent in notification')
    assert_equal(@observer.notifications[-1][1], @player1, 'correct player not sent in win notification')
  end
end