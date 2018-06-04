class ComputerPlayer
  attr_reader :candidate_words

  def self.player_with_dict_file(dict_file_name)
    ComputerPlayer.new(File.readlines(dict_file_name).map(&:chomp))
  end

  def initialize(dictionary)
    @dictionary = dictionary
  end

  # referee methods:

  def pick_secret_word
    @secret_word = @dictionary[rand(@dictionary.length)] # alternative: @dictionary.sample
    @secret_word.length
  end

  def check_guess(letter)
    indices = []
    characters = @secret_word.split("")
    characters.each_with_index  {|char, idx| indices << idx if char == letter}
    indices
  end

  def register_secret_length(length)
    @candidate_words = @dictionary.select {|word| word.length == length}
  end

  # guesser methods

  def guess(board)
    chart = letter_count(board)
    most_freq = chart.sort_by {|letter, count| count}
    letter, _ = most_freq.last


    letter
  end

  def handle_response(guess, response_indices)
    @candidate_words.delete_if do |word|
      delete = false

      characters = word.split("")
      characters.each_with_index do |letter, index|
        if (letter == guess) && (!response_indices.include?(index))
           delete = true
           break
         elsif (letter != guess) && (response_indices.include?(index))
           delete = true
           break
         end
      end

      delete
    end
  end

  def require_secret
    @secret_word
  end

  private

  def letter_count(board) # letter freq chart for missing position(s)
    chart = Hash.new(0)
    @candidate_words.each do |word|
      board.each_with_index do |letter, idx|
       chart[word[idx]] += 1 if letter == '__' || letter == nil
      end
    end
    chart
  end
end
