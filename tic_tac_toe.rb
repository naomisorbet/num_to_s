require "debugger"

class Board
  
  attr_accessor :positions
  
  def initialize
    @positions = create_positions
  end
  
  def create_positions
    positions = Array.new(3) { Array.new(3) { " " } }
  end
  
  def display_board
    @positions.each_with_index do |row, i|
      puts row.join(" | ")
      
      if i < 2
        puts "----------"
      end
    end
  end
  
  def display_moves
    cell_number = 1
    @positions.each do |row|
      puts
      row.each do |pos|
        if pos.eql?   " " 
          print " #{cell_number} "
        else
          print "   "
        end
  
        # if pos.equal? row.last
        #   puts 
        # end
        
        cell_number += 1 
      end
    end
    puts
  end
  
  def drawn?
    # i.e. nobody won.  Not related to display.
    self.full? && !self.won?
  end
  
  def empty?(row_coord, col_coord)
    @positions[row_coord][col_coord] == " "
  end
  
  def full?
    @positions.each do |row|
      row.each do |pos|
        if pos == " "
          return false
        end
      end
    end
    return true
  end
  
  def place_mark(coords, mark)
    @positions[coords[0]][coords[1]] = mark
  end
  
  def winner
    self.won?
  end
  
  def won?
    won_across || won_down || won_diag
  end
  
  def won_across
    @positions.each do |row|
# REFACTOR      
      if row.all? { |pos| pos == "X"}
        return row[0]
      elsif row.all? { |pos| pos == "O" }
        return row[0]
      end
    end
    nil
  end
  
  def won_down
    @positions[0].length.times do |i|
# REFACTOR
      if @positions.all? { |row| row[i] == "X" } 
        return @positions[0][i] 
      elsif @positions.all? { |row| row[i] == "O" }
        return @positions[0][i]
      end
    end
    nil
  end
  
  def won_diag
    pos_slope_marks = []
    neg_slope_marks = []
    @positions[0].length.times do |i|
      neg_slope_marks << @positions[i][i]
      pos_slope_marks << @positions[2-i][i]
    end
    diag_marks = [pos_slope_marks, neg_slope_marks]
# REFACTOR    
    diag_marks.each do |diag|
      if diag.all? { |mark| mark == "X" } 
        return diag[0]
      elsif diag.all? { |mark| mark == "O" }
        return diag[0]
      end
    end
    nil
  end
  
end


class Game

  attr_reader :player_1, :player_2, :board
  
  def initialize
    @player_1, @player_2 = get_players
    @board = Board.new
    self.play
  end
  
  def display_end_status
    if @board.won?
      puts "Congratulations, player #{@board.winner}!  You won!!!"
    elsif @board.drawn?
      puts "Game over.  Perhaps the only way to win is not to play."
    end
    
  end
  
  def get_players
    players_cipher = { "H" => HumanPlayer,
                       "C" => ComputerPlayer }
    
    player_1 = players_cipher[prompt(1)].new("O", self)
    player_2 = players_cipher[prompt(2)].new("X", self)
    [player_1, player_2]
  end
  
  def play
    
    players = [player_1, player_2]
    which = 0
    
    until @board.won? || @board.drawn?
      take_turn(players, which)
      which = 1 - which
    end
    
    display_end_status

  end
  
  def take_turn(players, which)
    players[which].move
  end
    
  def valid_move?(row_coord, col_coord)
    (0..2).include?(row_coord) &&
    (0..2).include?(col_coord) &&
    @board.empty?(row_coord, col_coord)
  end
  
  private
  
  def prompt(n)
    response = nil
    until response == "H" || response == "C"
      puts "Will player #{n} be Human (H) or Computer (C)?"
      response = gets.chomp
    end
    response
  end
end

class HumanPlayer
  
  def initialize(mark, game)
    @mark = mark
    @game = game
    @move_cipher = generate_move_cipher
  end
  
  def move
    pos = get_move
    @game.board.place_mark(pos, @mark)  
  end
  
  
  private
    
  
  def get_move
    puts "\nCurrent board:\n"
     @game.board.display_board
    
    puts "\nChoose your move, player #{@mark}! \n\nAvailable spaces:"
    @game.board.display_moves
    cell = gets.chomp.to_i
    move = @move_cipher[cell]
    until @game.valid_move?(move[0], move[1])
      puts "Please type an available move between 1 and 9 and hit enter."
      cell = gets.chomp.to_i
      move = @move_cipher[cell]
    end 
    move
  end
  
  def generate_move_cipher
    # maps UI digits 1-9 to [row, col] coordinates for use in nested array Board.positions
    move_cipher = {}
    cell_number = 1
    (0..2).each do |row|
      (0..2).each do |column|
        move_cipher[cell_number] = [row, column]
        cell_number += 1 
      end
    end
    move_cipher
  end
        
  
end

class ComputerPlayer
  
  def initialize(mark, game)
    @mark = mark
    @game = game
  end
  
  def move
    # chooses random available square only
    row_coord = rand(3)
    col_coord = rand(3)
    until @game.board.empty?(row_coord, col_coord)
      row_coord = rand(3)
      col_coord = rand(3)
    end
    @game.board.place_mark([row_coord, col_coord], @mark)
  end

end