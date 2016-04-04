# OO Rock Paper Scissors
require 'pry'

class Move
  VALUES = %w(rock paper scissors lizard spock)

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

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def >(other)
    # binding.pry
    (rock? && other.scissors?) ||
      (rock? && other.lizard?) ||
      (paper? && other.rock?) ||
      (scissors? && other.paper?) ||
      (spock? && other.scissors?) ||
      (lizard? && other.spock?) ||
      (scissors? && other.lizard?) ||
      (lizard? && other.paper?) ||
      (paper? && other.spock?) ||
      (spock? && other.rock?)
  end

  def <(other)
    # binding.pry
    (rock? && other.paper?) ||
      (paper? && other.scissors?) ||
      (scissors? && other.rock?) ||
      (scissors? && other.spock?) ||
      (spock? && other.lizard?) ||
      (lizard? && other.scissors?) ||
      (lizard? && other.rock?) ||
      (paper? && other.lizard?) ||
      (spock? && other.paper?) ||
      (rock? && other.spock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts 'Sorry, must enter a value.'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, scissors, spock, or lizard:'
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts 'Sorry, invalid choice'
    end
    # binding.pry
    self.move = Move.new(choice)
    self.history << self.move.to_s
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    self.history << self.move.to_s
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors, Spock, Lizard! First player to reach 10 wins!'
  end

  def display_goodbye_message
    puts 'Thanks for playing Rock, Paper, Scissors!'
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{human.name}'s moves: #{human.history}"
    puts "#{computer.name} chose #{computer.move}"
    puts "#{computer.name}'s moves: #{computer.history}"
  end

  def keep_score(player)
    if player == "human"
      human.score += 1
    else
      computer.score += 1
    end
  end

  def display_winner
    # binding.pry
    if human.move > computer.move
      puts "#{human.name} won!"
      keep_score("human")
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      keep_score("computer")
    else
      puts "It's a tie!"
    end
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
    puts "__________________________________________________________________"
    puts " "
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
  #clear player move-hstory
  end
end

RPSGame.new.play
