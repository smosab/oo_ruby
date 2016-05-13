require 'pry'

class Participant
  def hit

  end

  def stay

  end

  def busted?

  end

  def total

  end

  def self.<<(deck, participants_cards)
    # binding.pry
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
    display_welcome_message
    deal_cards(player, dealer, deck)
    show_initial_cards

    player_turn
    dealer_turn
    show_result
  end

  def display_welcome_message
    system 'clear'
    prompt "Welcome to Twenty-One!"
    sleep(1)
  end

  def deal_cards(player, dealer, deck)
    dealer.deal(player, dealer, deck)
  end

  def show_initial_cards
    playerscards_to_display = ""
    player.cards.each {|c| playerscards_to_display +=  c.join + " | "}
    # dealer.cards.each {|c| dealerscards_to_display +=  c.join + " | "}
    prompt "Dealing cards..."
    sleep(2)
    prompt "Your cards: #{playerscards_to_display} (total value: #{total(player.cards)})"
    prompt "Dealers cards: #{dealer.cards[0].join} | \u{1F0A0}"
  end

  private

  def total(cards)
    # binding.pry
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
end

new_game = Game.new
new_game.start
