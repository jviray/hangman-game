require_relative 'human_player'
require_relative 'computer_player'

class Hangman
  attr_reader :guesser, :referee, :board

  MAX_TURNS = 7

  def initialize(players = {})
    @guesser = players[:guesser]
    @referee = players[:referee]
    @num_of_turns = MAX_TURNS
  end

  def setup
    length = @referee.pick_secret_word
    @board = Array.new(length, '__')
    @guesser.register_secret_length(length)
  end

  def play_game
    p "Let's play Hangman!"
    puts
    self.setup

    until @num_of_turns == 0
      take_turn
      if won?
        p @board
        puts "Guesser wins!"
        return
      end
    end

    puts "Sorry you're all out of turns!"
    puts "Word was: #{@referee.require_secret.upcase}"
    puts "Guesser loses!"

    nil
  end

  def take_turn
    guess = @guesser.guess(@board)
    indices = @referee.check_guess(guess)
    @num_of_turns -= 1 if indices == []
    update_board(guess, indices)
    @guesser.handle_response(guess, indices)
  end

  def update_board(guess, indices)
    indices.each do |idx|
      @board[idx] = guess.upcase
    end
  end

  def won?
    @board.include?('__') ? false : true
  end

end

if $PROGRAM_NAME == __FILE__
  print "Would you like to play as the guesser (Y/N)? "
  input = gets.chomp.downcase
  human_player = HumanPlayer.new
  computer_player = ComputerPlayer.player_with_dict_file("dictionary.txt")
  if input == "y"
    Hangman.new(guesser: human_player, referee: computer_player).play_game
  elsif input == "n"
    Hangman.new(guesser: computer_player, referee: human_player).play_game
  end
end
