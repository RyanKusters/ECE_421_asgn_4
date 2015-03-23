require 'gtk2'
require_relative 'GameFactory.rb'
require_relative 'ColumnController.rb'
class GameBoard
	def initialize(choices)
	
	if choices[0] = "Connect4"
		gameType = ConnectFour.name
		@image_map = {0=>"Empty_Grid.png", 1=>"Red_Grid.png", 2=>"Black_Grid.png"}
		player1Piece = "Red"
		player2Piece = "Black"
	else
		gameType = OttoToot.name
		@image_map = {0=>"Empty_Grid.png", 1=>"O_Grid.png", 2=>"T_Grid.png"}
		player1Piece = "O"
		player2Piece = "T"
	end

	diff_map = {"Easy"=>1,"Medium"=>2,"Hard"=>3}
	
	if choices[1] == "Computer"
		player1AI = diff_map[choices[3]]
	else
		player1AI = false
	end

	if choices[2] == "Computer"
		player2AI = diff_map[choices[3]]
	else
		player2AI = false
	end
	
	dimensions = [6,7]
	@game = createGame(gameType, player1AI, player2AI, player1Piece, player2Piece, dimensions)
	@columnController = ColumnController.new(@game)

  Gtk.init
    @builder = Gtk::Builder::new
    @builder.add_from_file("Game_Screen.glade")
	
    
	
# Step 1: get the window to terminate the program when it's destroyed
#
    window = @builder.get_object("window1")
    window.signal_connect( "destroy" ) { Gtk.main_quit }

# Setup the Quit Button
	@builder.get_object("button1").signal_connect("clicked"){window.destroy}


# Setup default Images for the board. So a Fresh Empty Game.
(1..42).each{|i| @builder.get_object("image"+i.to_s).set("Empty_Grid.png")}

# Setup the Info Bar
	@builder.get_object("label1").text = "Let's Play"
# Setup the How to play
	@builder.get_object("label2").text = "How to Play: Connect pieces of your pattern\n" +
	"by row, column, or diagonally before your opponent does."

# Setup Clickable Images
(1..7).each{|i| @builder.get_object("eventbox" + i.to_s).signal_connect("button_press_event"){play_move(i)}}


window.show()
    Gtk.main()
	end

def notify(*args)
	flags_map = {'CHANGE_TURN'=>0, 'WIN'=>1, 'STALEMATE'=>2, 'COLUMN_FULL'=>3}

	if(flags_map[args[0]] == 0)

		board = args[1]
		message = args[2]
	
		#Update the Board View
		state_array = Array.new
		board.each{|row| row.each{|element| state_array << element}}
		(1..42).each{|i| @builder.get_object("image"+i.to_s).set(@image_map[state_array[i-1]])}
		
		# Play Continues	
		@builder.get_object("label1").text = message + " take your turn."
	
	elsif(flags_map[args[0]] == 1) 
		# Declare the Winner in the Info box up top
		message = args[1]
		@builder.get_object("label1").text = message + " wins!"
	elsif(flags_map[args[0]] == 2)
		#Stalemate Tell the Info Box
		@builder.get_object("label1").text = "Stalemate!"
	elsif(flags_map[args[0]] == 3)
		#Column is full, Tell the player to pick another column
		@builder.get_object("label1").text = "Column Full. Try a different spot."
	else
		# Something has gone horribly wrong	
	end
	
end

def play_move(col)
	@columnController.clickColumn(col)
end

	
end
