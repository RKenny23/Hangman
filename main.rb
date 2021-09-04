class Hangman
  
  def initialize
    @letters = ('a'..'z').to_a
    @word = words.sample.chomp
    @board = ""
    @lives = 7
    @guesses = []
    
    @word.size.times do
      @board += "_ "
    end
  end

  def words
    # File.readlines("5desk.txt")
    # # File.readlines("5desk.txt").strip!.each do |line|
    # #   puts line if line.size >= 5 && line.size <= 12
    # # end
    ["baseball", "soccer", "football"]
  end

  def print_board(last_guess = nil)
    update_board(last_guess) unless last_guess.nil?
    puts "So far, you've tried: #{@guesses.join(', ')}"
    puts "\n", @board, "\n"
  end

  def update_board(last_guess)
    new_board = @board.split

    new_board.each_with_index do |letter, index|
      # replace blank values with letter if matches letter in word
      if letter == '_' && @word[index] == last_guess
        new_board[index] = last_guess
      end
    end

    @board = new_board.join(' ')
  end

  def make_guess
    while @lives > 0 && !won?
      puts "Enter a letter:"
      guess = gets.chomp.downcase
      good_guess = @word.include?(guess)
      
      if guess == "exit"
        puts "Thanks for playing!"
      elsif good_guess && !@guesses.include?(guess)
        @guesses << guess
        puts "Good guess!"
        print_board(guess)
        make_guess
      elsif guess.length > 1 || !@letters.include?(guess)
        puts "Invalid guess! Please try again."
        print_board(guess)
        make_guess
      elsif @guesses.include?(guess)
        puts "You already guessed that letter!"
        print_board(guess)
        make_guess   
      else
        @lives -= 1
        @guesses << guess
        puts "Sorry! You have #{@lives} guesses left. Try again." unless @lives == 0
        print_board(guess)
        make_guess
      end
    end

    if won?
      puts "Great job! You win!"
      play_again
    else
      puts "You lose!", "The word was #{@word}."
      play_again
    end

  end

  def start
    puts "\n", "<<<Hangman by Ryan>>>", "\n"
    puts "Your word is #{@word.length} characters long."
    puts "To quit type 'exit'"
    puts "\n", @board, "\n"
    make_guess
  end

  def won?
    !@board.include?("_")
  end

  def play_again
    puts "\n", "Play again? y/n: "
    choice = gets.chomp.downcase
    if choice == 'n'
      exit
    elsif choice == 'y'
      initialize
      start
    end
  end     
end

game = Hangman.new
game.start
