require 'pry'

class Participant
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

    correct_for_aces(sum)

    sum
  end

  def correct_for_aces(sum)
    cards.select { |c| c[1] == 'A' }.count.times do
      break if sum <= 21
      sum -= 10
    end
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
    loop do
      deal_cards(player, dealer, deck)
      show_cards
      player_turn
      dealer_turn unless player.busted?(player.cards)
      show_cards("no")
      show_result
      initialize
      break unless play_again?
    end
  end

  def display_welcome_message
    system 'clear'
    prompt "Welcome to Twenty-One!"
    sleep(1)
  end

  def deal_cards(player, dealer, deck)
    prompt "Dealing cards..."
    sleep(1)
    dealer.deal(player, dealer, deck)
  end

  def joinor(arr, delimiter=', ', word='or')
    arr[-1] = "#{word} #{arr.last}" if arr.size > 1
    arr.join(delimiter)
  end

  def show_player_or_dealer_cards(participant)
    participant_cards_to_display = ""

    participant.cards.each do |c|
      # binding.pry
      if participant.cards.index(c) != participant.cards.size - 1
        participant_cards_to_display += c.join + " | "
      else
        participant_cards_to_display += c.join
      end
    end
    participant_cards_to_display
  end

  def show_player_cards
    prompt "Your cards: #{show_player_or_dealer_cards(player)} (total value: #{player.total(player.cards)})"
  end

  def show_cards(show_initial_cards = "yes")
    if show_initial_cards == "no"
      system 'clear'
      show_player_cards
      prompt "Dealers cards: #{show_player_or_dealer_cards(dealer)} (total value: #{dealer.total(dealer.cards)})"
    else
      system 'clear'
      show_player_cards
      prompt "Dealers cards: #{dealer.cards[0].join} | \u{1F0A0}"
    end
  end

  def player_turn
    loop do
      if hit_or_stay == 'h'
        player.cards << deck.pop
        show_cards("yes")
      else break
      end
      break if player.busted?(player.cards)
    end

    if player.busted?(player.cards)
      prompt "You busted!"
      sleep(2)
    else
      puts "You chose to stay!"
      sleep(1)
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
    sleep(1)
    loop do
      break unless dealer.total(dealer.cards) <= 17
      prompt "Dealer hits!"
      sleep(1)
      dealer.cards << deck.pop
      show_cards("no")
      break if dealer.busted?(dealer.cards)
    end

    if dealer.busted?(dealer.cards)
      show_cards("no")
      prompt "Dealer busted!"
      sleep(2)
    else
      show_cards("no")
      prompt "Dealer stays..."
      sleep(1)
    end
  end

  def show_result
    total_of_players_cards = player.total(player.cards)
    total_of_dealers_cards = dealer.total(dealer.cards)
    if !player.busted?(player.cards) && (total_of_players_cards > total_of_dealers_cards || dealer.busted?(dealer.cards))
      prompt "You win!"
    elsif !dealer.busted?(dealer.cards) && (total_of_dealers_cards > total_of_players_cards || player.busted?(player.cards))
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
