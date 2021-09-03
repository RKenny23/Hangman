class Hangman
  
  def initialize
    @letters = ('a'..'z').to_a
    @word = words.sample.chomp
    @word_teaser = ""
    @lives = 7
    @guesses = []
    
    @word.size.times do
      @word_teaser += "_ "
    end
  end

  def words
    # File.readlines("5desk.txt")
    # # File.readlines("5desk.txt").strip!.each do |line|
    # #   puts line if line.size >= 5 && line.size <= 12
    # # end
    ["baseball", "soccer", "football"]
  end

  def print_teaser(last_guess = nil)
    update_teaser(last_guess) unless last_guess.nil?
    puts "So far, you've tried: #{@guesses.join(', ')}"
    puts "\n", @word_teaser, "\n \n"
  end

  def update_teaser(last_guess)
    new_teaser = @word_teaser.split

    new_teaser.each_with_index do |letter, index|
      # replace blank values with letter if matches letter in word
      if letter == '_' && @word[index] == last_guess
        new_teaser[index] = last_guess
      end
    end

    @word_teaser = new_teaser.join(' ')
  end

  def make_guess
    if @lives > 0
      puts "Enter a letter:"
      guess = gets.chomp.downcase
      good_guess = @word.include?(guess)
      
      if guess == "exit"
        puts "Thanks for playing!"
      elsif good_guess && !@guesses.include?(guess)
        @guesses << guess
        puts "Good guess!"
        print_teaser(guess)
        make_guess
      elsif guess.length > 1 || !@letters.include?(guess)
        puts "Invalid guess! Please try again."
        print_teaser(guess)
        make_guess
      elsif @guesses.include?(guess)
        puts "You already guessed that letter!"
        print_teaser(guess)
        make_guess      
      else
        @lives -= 1
        @guesses << guess
        puts "Sorry! You have #{@lives} guesses left. Try again." unless @lives == 0
        print_teaser(guess)
        make_guess
      end
    else
      puts "You ran out of guesses. Game over!", "The word was #{@word}."
    end
  end

  def begin
    puts "Hangman by Ryan", "\n"
    puts "Your word is #{@word.length} characters long."
    puts "To quit type 'exit'"
    print_teaser
    make_guess
  end


    
end

game = Hangman.new
game.begin
