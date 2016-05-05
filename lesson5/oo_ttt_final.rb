require 'pry'
class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def square_five_unmarked?
    # binding.pry
    @squares[5].marker == " "
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square
    # binding.pry
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_markers?(squares)
        return @squares.key(squares.select {|sqr| sqr.unmarked?}.pop)
      end
    end
    nil
  end

  def find_winning_square
    # binding.pry
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if two_identical_computer_markers?(squares)
        return @squares.key(squares.select {|sqr| sqr.unmarked?}.pop)
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
    # (1..9).each do |key|
    #   # binding.pry
    #   @squares[key] = Square.new(key)
    # end
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    # binding.pry
    puts "     |     |"
    puts "  #{Square.return_square_indicator(@squares[1], @squares)}  |  #{Square.return_square_indicator(@squares[2], @squares)}  |  #{Square.return_square_indicator(@squares[3], @squares)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{Square.return_square_indicator(@squares[4], @squares)}  |  #{Square.return_square_indicator(@squares[5], @squares)}  |  #{Square.return_square_indicator(@squares[6], @squares)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{Square.return_square_indicator(@squares[7], @squares)}  |  #{Square.return_square_indicator(@squares[8], @squares)}  |  #{Square.return_square_indicator(@squares[9], @squares)}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def two_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

  def two_identical_computer_markers?(squares)
    markers = squares.select {|x| x.marker == "O"}.collect(&:marker)
    return false if markers.size != 2
    markers.min == markers.max
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    # binding.pry
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def self.return_square_indicator(square, squares)
    # binding.pry
    if !!square.unmarked?
    squares.key(square)
    else
    square.marker
    end
  end
end

class Player
  attr_reader :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER
  WHO_GOES_FIRST = "choose" # human, computer, or choose

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    # @current_marker = FIRST_TO_MOVE
    @current_marker = WHO_GOES_FIRST
  end

  def play_round
    loop do
      # binding.pry
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
  end

  def keep_score
    if board.winning_marker == HUMAN_MARKER
      human.score += 1
      elsif board.winning_marker == COMPUTER_MARKER
        computer.score += 1
      end
  end

  def someone_won_five_rounds?
    human.score >= 5 || computer.score >= 5
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board
      ask_who_goes_first
      loop do

        play_round
        display_round_winner
        sleep(1)
        keep_score
        # binding.pry
        break if someone_won_five_rounds?
        reset
        clear_screen_and_display_board
      end

      display_result
      sleep(2)
      break unless play_again?
      reset
      reset_player_scores
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Tic Tac Toe! First to 5 wins!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're a #{human.marker} and your score is: #{human.score}."
    puts "Computer is a #{computer.marker}. and its score is #{computer.score}"
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, delimiter=', ', word='or')
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.join(delimiter)
  end

  def human_moves
    # puts "Choose a square (#{board.unmarked_keys.join(', ')}): "
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    # binding.pry
    square_to_block = board.find_at_risk_square
    winning_square = board.find_winning_square
    if !!winning_square
      board[winning_square] = computer.marker
    elsif !!square_to_block
      # binding.pry
      board[square_to_block] = computer.marker
    elsif !!board.square_five_unmarked?
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def ask_who_goes_first
    puts "Who would you like to go first? human or computer?"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if answer == "human" || answer == "computer"
      puts "Sorry, that's an invalid choice."
    end
    @current_marker = answer
  end

  def current_player_moves
    # binding.pry
    if @current_marker == "human"
    # if @current_marker == HUMAN_MARKER
      human_moves
      @current_marker = "computer"
      # @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = "human"
      # @current_marker = "HUMAN_MARKER"
    end
  end

  def display_round_winner
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won this round..."
    when computer.marker
      puts "Computer won this round..."
    else
      puts "It's a tie!"
    end
  end

    def display_result
    clear_screen_and_display_board

    if human.score >= 5
      puts "You won all five rounds!"
    elsif computer.score >= 5
      puts "Computer won all five rounds!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    # @current_marker = FIRST_TO_MOVE
    clear
  end

  def reset_player_scores
    human.score = 0
    computer.score = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play