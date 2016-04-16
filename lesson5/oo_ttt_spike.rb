# 1. Write a description of the problem and extract major nouns and verbs.

Tic tac toe is a two player game played on a 3 x 3 board. The object of the game is to win by placing three consective 'O's or 'X's on the grid diagnoally or horizontally.

Nouns:

  - player
  - square
  - board/grid
  - O and X

Verbs:

  - play
  - place x/o (make move)

# 2. Make an initial guess at organizing the verbs into nouns and do a spike to explore the problem with temporary code.

- player
  - plays
  - marks board
- board
  - display
  - update


class Player
  def initialize

  end

  def mark

  end
end

class Board
  def initialize

  end

  def display_board

  end

  def update

  end
end

class Square
  def initialize

  end
end

class TTTgame
  def play
    display_welcome_message
    loop do
      display_board
      first_player_moves
      break if someone_one? || board_full?

      first_player_moves
      break if someone_one? || board_full?
    end
  end
  display_result
  display_goodbye_message
end

# we'll kick off the game like this
game = TTTGame.new
game.play

# 3. Optional - when you have a better idea of the problem, model your thoughts into CRC cards.

