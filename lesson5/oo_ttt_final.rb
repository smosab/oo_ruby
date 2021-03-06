class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    @human_marker = nil
    @computer_marker = nil
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def square_five_unmarked?
    @squares[5].marker == " "
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker # three identical markers
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 3)
        return squares.first.marker
      end
    end
    nil
  end

  def find_winning_or_at_risk_square
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if identical_markers?(squares, 2)
        return @squares.key(squares.select(&:unmarked?).pop)
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw(display_numbers = "no")
    puts "     |     |"
    puts "  #{Square.square_indicator(@squares[1], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[2], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[3], @squares, display_numbers)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{Square.square_indicator(@squares[4], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[5], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[6], @squares, display_numbers)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{Square.square_indicator(@squares[7], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[8], @squares, display_numbers)}  |  #{Square.square_indicator(@squares[9], @squares, display_numbers)}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def set_players_markers(human, computer)
    @human_marker = human.marker
    @computer_marker = computer.marker
  end

  private

  def identical_markers?(squares, number_of_markers)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != number_of_markers
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
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

  def self.square_indicator(square, squares, display_numbers)
    if square.unmarked? && display_numbers == "yes"
      squares.key(square)
    else
      square.marker
    end
  end
end

class Player
  attr_accessor :marker, :score, :name

  def initialize(marker=nil)
    @marker = marker
    @score = 0
  end
end

class TTTGame
  WHO_GOES_FIRST = "choose" # human, computer or choose (default is computer)
  DEFAULT_HUMAN_NAMES = ["Joe Shmoe", "TicTacToeMoe", "Tupac", "Elvis", "Peyton Manning", "Mr. Rodgers", "Jane Doe"]
  DEFAULT_COMPUTER_NAMES = ["CP30", "Lion Force Voltron, Defender of the Universe", "T-1000", "Johnny 5", "Bender", "R2-D2"]

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    @current_marker = WHO_GOES_FIRST
    @first_to_move = nil
  end

  def update_board_with_players_markers(human, computer)
    board.set_players_markers(human, computer)
  end

  def play_round
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board
    end
    reset_first_to_move
    display_round_winner
    keep_score
  end

  def keep_score
    if board.winning_marker == human.marker
      human.score += 1
    elsif board.winning_marker == computer.marker
      computer.score += 1
    end
  end

  def someone_won_five_rounds?
    human.score >= 5 || computer.score >= 5
  end

  def reset_first_to_move
    @current_marker = @first_to_move
  end

  def set_markers
    human.marker = "X"
    computer.marker = "O"
    update_board_with_players_markers(human, computer)
  end

  def set_computer_marker
    case human.marker
    when "X"
      computer.marker = "O"
    when "O"
      computer.marker = "X"
    end
    update_board_with_players_markers(human, computer)
  end

  def choose_player
    puts "Do you want to go first? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if answer[0] == "y" || answer == "n"
      puts "Sorry, that's not a valid choice."
    end
    assign_markers_first_to_move(answer)
  end

  def ask_who_goes_first
    if WHO_GOES_FIRST == "choose"
      choose_player
    elsif WHO_GOES_FIRST == "human"
      answer = "human"
      assign_markers_first_to_move(answer)
    else
      answer = "computer"
      assign_markers_first_to_move(answer)
    end
  end

  def assign_markers_first_to_move(answer)
    case answer
    when 'y'
      @current_marker = "human"
    when 'n'
      @current_marker = "computer"
    end
    @first_to_move = @current_marker
  end

  def ask_player_to_choose_marker
    if @first_to_move == "human"
      puts "Please pick your choice of marker: X or O"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if answer.downcase == "x" || answer.downcase == "o"
        puts "Sorry, please enter an 'X' or 'O' "
      end
      human.marker = answer.upcase
      set_computer_marker
    else set_markers
    end
  end

  def set_default_human_name
    human.name = DEFAULT_HUMAN_NAMES.sample
    puts "Your name will be..."
    sleep(1)
    puts "#{human.name}!"
  end

  def set_default_computer_name
    computer.name = DEFAULT_COMPUTER_NAMES.sample
    puts "The computer's name will be..."
    sleep(1)
    puts "#{computer.name}!"
  end

  def set_human_name
    puts "Please enter your name: (hit enter for a random name)"
    loop do
      human.name = gets.chomp
      break unless human.name =~ /[^a-zA-z0-9]/
      puts "Sorry, please enter a valid name or press enter for a random one."
    end
    set_default_human_name if human.name.empty?
  end

  def set_computer_name
    puts "Please enter the name for the computer: (hit enter for a random name)"
    loop do
      computer.name = gets.chomp
      break unless computer.name =~ /[^a-zA-z0-9]/
      puts "Sorry, please enter a valid name or press enter for a random one."
    end
    set_default_computer_name if computer.name.empty?
  end

  def set_player_names
    set_human_name
    set_computer_name
  end

  def display_welcome_message_and_set_variables
    display_welcome_message
    set_player_names
    ask_who_goes_first
    ask_player_to_choose_marker
    clear
  end

  def play
    display_welcome_message_and_set_variables
    loop do
      display_board_with_numbers
      loop do
        play_round
        break if someone_won_five_rounds?
        reset
        clear_screen_and_display_board_with_numbers
      end
      display_result
      break unless play_again?
      reset_board_and_player_scores
      display_play_again_message
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    clear
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

  def display_board(display_numbers = "no")
    puts "#{human.name} you're an #{human.marker} and your score is: #{human.score}."
    puts "#{computer.name} is a #{computer.marker}. and its score is #{computer.score}"
    puts ""
    board.draw(display_numbers)
    puts ""
  end

  def display_board_with_numbers
    display_board("yes")
  end

  def clear_screen_and_display_board_with_numbers
    display_board_with_numbers
  end

  def joinor(arr, delimiter=', ', word='or')
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.join(delimiter)
  end

  def human_moves
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
    if board.square_five_unmarked?
      play_square_five
    elsif board.find_winning_or_at_risk_square
      play_offense
    else
      play_random_square
    end
  end

  def play_square_five
    board[5] = computer.marker
  end

  def play_offense
    board[board.find_winning_or_at_risk_square] = computer.marker
  end

  def play_defense
    board[board.find_at_risk_square] = computer.marker
  end

  def play_random_square
    board[board.unmarked_keys.sample] = computer.marker
  end

  def current_player_moves
    if @current_marker == "human"
      human_moves
      @current_marker = "computer"
    else
      computer_moves
      @current_marker = "human"
    end
  end

  def display_round_winner
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} won this round..."
    when computer.marker
      puts "#{computer.name} won this round..."
    else
      puts "It's a tie!"
    end
    sleep(1)
  end

  def display_result
    clear_screen_and_display_board
    if human.score >= 5
      puts "You won all five rounds!"
    elsif computer.score >= 5
      puts "#{computer.name} won all five rounds!"
    end
    sleep(2)
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
    clear
  end

  def reset_board_and_player_scores
    reset
    human.score = 0
    computer.score = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
    sleep(1)
  end
end

game = TTTGame.new
game.play
