require 'pry'

class Participant
  def hit(deck, participants_cards)

  end

  def stay

  end

  def clear_hands(participant)
    participant.cards = []
  end

  def busted?(cards)
    total(cards) > 21
  end

  def total(cards)
    values = cards.map { |card| card[1] }

    sum = 0
    values.each do |value|
      if value == "A"
        sum += 11
      elsif value.to_i == 0 # J, Q, K
        sum += 10
      else
        sum += value.to_i
      end
    end
    sum
  end

  def self.<<(deck, participants_cards)
    participants_cards.push(deck.pop)
  end
end

class Player < Participant
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

class Dealer < Participant

  attr_accessor :cards

  def initialize
    @cards = []
  end

  def deal(player, dealer, deck)
    2.times do
      player.cards << deck.pop
      dealer.cards << deck.pop
    end
  end
end

class Deck
  SUITS = ["\u{2660}", "\u{2665}", "\u{2666}", "\u{2663}"]
  RANKS = ('2'..'10').to_a + %w(J Q K A)

  attr_reader :deck

  def initialize
    @deck = SUITS.product(RANKS).shuffle
  end

  def pop
    deck.pop
  end
end

class Card
  def initialize

  end
end

class Game

  attr_accessor :player, :dealer
  attr_reader :deck

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def prompt(msg)
    puts "=> #{msg}"
  end

  def start
    loop do
      display_welcome_message
      deal_cards(player, dealer, deck)
      show_cards("yes")
      player_turn
      dealer_turn unless player.busted?(player.cards)
      show_result
      initialize
    break unless play_again?
    end
  end

  def display_welcome_message
    system 'clear'
    prompt "Welcome to Twenty-One!"
    sleep(2)
  end

  def deal_cards(player, dealer, deck)
    dealer.deal(player, dealer, deck)
  end

  def show_cards(show_initial_cards = "yes")
    system 'clear'
    playerscards_to_display = ""
    dealerscards_to_display = ""
    player.cards.each {|c| playerscards_to_display +=  c.join + " | "}
    if show_initial_cards == "no"
      system 'clear'
      prompt "Your cards: #{playerscards_to_display} (total value: #{player.total(player.cards)})"
      dealer.cards.each {|c| dealerscards_to_display +=  c.join + " | "}
      prompt "Dealers cards: #{dealerscards_to_display} (total value: #{dealer.total(dealer.cards)})"
    else
    prompt "Dealing cards..."
    sleep(1)
    system 'clear'
    prompt "Your cards: #{playerscards_to_display} (total value: #{player.total(player.cards)})"
    prompt "Dealers cards: #{dealer.cards[0].join} | \u{1F0A0}"
    end
  end

  def player_turn
    loop do
      if hit_or_stay == 'h'
        player.cards << deck.pop
        show_cards("no")
      else break
      end
      break if player.busted?(player.cards)
    end

    if player.busted?(player.cards)
      prompt "You busted! Dealer wins!"
      sleep(2)
    else
      puts "You chose to stay!"
      sleep(2)
    end
  end

  private

  def hit_or_stay
    loop do
      prompt "(h)it or (s)tay?"
      answer = gets.chomp.downcase
      break(answer) if ["h", "s"].include?(answer)
      prompt "Please enter 'h' or 's'"
    end
  end

  def dealer_turn
    prompt "Dealers turn!"
    sleep(2)
    loop do
      break unless dealer.total(dealer.cards) <= 17
      prompt "Dealer hits!"
      sleep(2)
      dealer.cards << deck.pop
      show_cards("no")
      break if dealer.busted?(dealer.cards)
    end

    if dealer.busted?(dealer.cards)
      show_cards("no")
      prompt "Dealer busted! You win!"
      sleep(2)
      else
      show_cards("no")
      prompt "Dealer stays..."
      sleep(2)
    end
  end

  def show_result
    total_of_players_cards = player.total(player.cards)
    total_of_dealers_cards = dealer.total(dealer.cards)
    if !player.busted?(player.cards) && total_of_players_cards > total_of_dealers_cards
      prompt "You win!"
    elsif !dealer.busted?(dealer.cards) && total_of_dealers_cards > total_of_players_cards
      prompt "Dealer wins!"
    elsif total_of_players_cards == total_of_dealers_cards
      prompt "It's a push(draw)!"
    end
  end

  def play_again?
    prompt "Would you like to play again (y/n)?"
    gets.chomp.downcase.start_with?('y')
  end
end

new_game = Game.new
new_game.start
