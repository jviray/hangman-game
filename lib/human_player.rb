class HumanPlayer
  # referee methods:

  def pick_secret_word
    puts "Input secret word length below:"
    length = gets.chomp.to_i
  end

  def check_guess(guess)
    puts "Which indices have the letter \'#{guess.upcase}\'?"
    indices = gets.chomp.downcase
    if indices == 'none'
      return indices = []
    else
      indices.split(", ").map do |idx|
        idx.to_i
      end
    end
  end

  # guesser methods

  def register_secret_length(length)
    puts "Secret word is #{length} letters long:"
  end

  def guess(board)
    p board
    puts "Guess a letter:"
    input = gets.chomp.downcase
  end

  def handle_response(guess, response_indices)
    if response_indices == []
      puts "There is no letter \'#{guess.upcase}\'"
    else
      puts "Found \'#{guess.upcase}\' at positions #{response_indices}:"
    end
  end

  def require_secret
    puts "What word were you thinking of?"
    gets.chomp.upcase
  end
end
