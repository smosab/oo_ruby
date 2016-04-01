# OO Rock Paper Scissors

class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other)
    (rock? && other.scissors?) ||
      (paper? && other.rock?) ||
      (scissors? && other.paper?)
  end

  def <(other)
    (rock? && other.paper?) ||
      (paper? && other.scissors?) ||
      (scissors? && other.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's yo' name boy?"
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, must enter a value.'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, or scissors:'
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts 'Sorry, invalid choice'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors! First player to reach 10 wins!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors!'
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def keep_score(player)
    if player == "human"
      human.score += 1
    else
      computer.score += 1
    end
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      keep_score("human")
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      keep_score("computer")
    else
      puts "It's a tie!"
    end
    puts "Player score: #{human.score} Computer score: #{computer.score} "
  end

  def play_again?
    answer = nil
    loop do
      puts "#{scored_ten?} wins!"
      puts 'Would you like to play again? (y/n)?'
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts 'Sorry, must be y or n'
    end
    human.score = 0
    computer.score = 0
    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def scored_ten?
    if human.score == 5
      return human.name
    elsif computer.score == 5
      return computer.name
    end
  end

  def play
    display_welcome_message
  loop do
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      break if scored_ten?
    end
    break unless play_again?
  end
  display_goodbye_message
  end
end

RPSGame.new.play
