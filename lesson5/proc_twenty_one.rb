require 'pry'

def prompt(msg)
  puts "=> #{msg}"
end

# SUITS = ["H", "D", "S", "C"]
SUITS = ["\u{2660}", "\u{2665}", "\u{2666}", "\u{2663}"]
RANKS = ('2'..'10').to_a + %w(J Q K A)

def initialize_deck
  SUITS.product(RANKS).shuffle
end

def deal_cards(players_cards, dealers_cards, deck)
  2.times do
    players_cards << deck.pop
    dealers_cards << deck.pop
  end
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
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

  # correct for Aces
  values.count { |value| value == "A" }.times do
    sum -= 10 if sum > 21
  end

  sum
end

def display_opening_cards(players_cards, dealers_cards)
  # binding.pry
  cards_to_display = ""
  players_cards.each {|c| cards_to_display +=  c.join + " | "}
  prompt "Dealing cards..."
  sleep(2)
  prompt "Your cards: #{cards_to_display} (total value: #{total(players_cards)})"
  prompt "Dealers cards: #{dealers_cards[0].join} | \u{1F0A0}"
end

def display_score(players_cards, dealers_cards)
  cards_to_display = ""
  players_cards.each {|c| cards_to_display +=  c.join + " | "}
  system "clear"
    # binding.pry
  prompt "Your cards: #{cards_to_display} (total value: #{total(players_cards)})"
  prompt "Dealers cards: #{dealers_cards[0].join} | #{dealers_cards[1].join}  (total value: #{total(dealers_cards)})"
end

def busted?(cards)
  total(cards) > 21
end

def dealer_hits(dealers_cards, deck)
  dealers_cards << deck.pop
end

def player_hits(players_cards, deck)
  players_cards << deck.pop
end

def hit_or_stay
  loop do
    prompt "(h)it or (s)tay?"
    answer = gets.chomp.downcase
    break(answer) if ["h", "s"].include?(answer)
    prompt "Please enter 'h' or 's'"
  end
end

def players_turn(players_cards, dealers_cards, deck)
  loop do
    if hit_or_stay == 'h'
      player_hits(players_cards, deck)
      display_score(players_cards, dealers_cards)
    else break
    end
    break if busted?(players_cards)
  end

  if busted?(players_cards)
    prompt "You busted! Dealer wins!"
    sleep(2)
  else
    puts "You chose to stay!"
    sleep(2)
  end
end

def dealers_turn(dealers_cards, players_cards, deck)
    prompt "Dealers turn!"
    sleep(2)
  loop do
    break unless total(dealers_cards) <= 17
    prompt "Dealer hits!"
    sleep(2)
    dealer_hits(dealers_cards, deck)
    display_score(players_cards, dealers_cards)
    break if busted?(dealers_cards)
  end

  if busted?(dealers_cards)
    prompt "Dealer busted! You win!"
    sleep(2)
  else
    prompt "Dealer stays..."
    sleep(2)
  end
end


def who_is_winner(players_cards, dealers_cards)
  total_of_players_cards = total(players_cards)
  total_of_dealers_cards = total(dealers_cards)

  if !busted?(players_cards) && total_of_players_cards > total_of_dealers_cards
    prompt "You win!"
  elsif !busted?(dealers_cards) && total_of_dealers_cards > total_of_players_cards
    prompt "Dealer wins!"
  elsif total_of_players_cards == total_of_dealers_cards
    prompt "It's a push(draw)!"
  end
end

def play_again?
  prompt "Would you like to play again (y/n)?"
  gets.chomp.downcase.start_with?('y')
end

def welcome_msg
  system 'clear'
  prompt "Welcome to Twenty-One!"
  sleep(1)
end

welcome_msg
loop do
  players_cards = []
  dealers_cards = []

  deck = initialize_deck

  deal_cards(players_cards, dealers_cards, deck)

  display_opening_cards(players_cards, dealers_cards)

  players_turn(players_cards, dealers_cards, deck)

  dealers_turn(dealers_cards, players_cards, deck) unless busted?(players_cards)

  who_is_winner(players_cards, dealers_cards)

  break unless play_again?
end

prompt "Thanks for playing!"
