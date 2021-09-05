require 'yaml'

class Hangman
  
  def initialize
    @letters = ('a'..'z').to_a
    @word = get_word
    @board = ""
    @lives = 9
    @guesses = []
    
    @word.size.times do
      @board += "_ "
    end
  end
  
  def get_word
    clean_words = []
    lines = File.readlines("5desk.txt")

    lines.each do |line| 
      line.gsub!(/\r\n?/, '')
      clean_words << line if line.length > 4 && line.length < 13
    end
    clean_words.sample
  end

  def game_menu
    puts "\n", "<<<Hangman by Ryan>>>", "\n"
    puts "Type '1' to start a new game or '2' to load a game."
    puts "To save at any point type 'save'. If you wish to exit type 'quit'."
    input = gets.chomp
    if input == '1'
      puts "Starting a new game..."
      sleep(1)
      start_game 
    elsif input == '2'
      load_game
    else
      exit
    end
  end

  def start_game
    puts "\n", "Your word is #{@word.length} characters long."
    puts "\n", @board, "\n"
    make_guess
  end


  def print_board(last_guess = nil)
    update_board(last_guess) unless last_guess.nil?
    puts "So far, you've tried: #{@guesses.join(', ')}"
    puts "\n", @board, "\n"
  end

  def update_board(last_guess)
    new_board = @board.split

    new_board.each_with_index do |letter, index|
      # replace underscores with letter if matches letter in word
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
      
      if guess.downcase == "exit"
        puts "Thanks for playing!"
        exit
      elsif guess.downcase == "save"
        save_game
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
    elsif @lives == 0
      puts "You lose!", "The word was #{@word}."
      play_again
    end
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
      game_menu
    end
  end 
  
  def save_game
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    saved_games = Dir.glob('saved_games/*')

    loop do
      puts 'Enter name of your save file: '
      filename = gets.chomp
      if saved_games.include?("saved_games/#{filename}.yml")
        puts "\n," "File aready exists!"
        next
      else
        File.open("./saved_games/#{filename}.yml", 'w') do |file| 
          file.write(YAML.dump(self))
        end
        puts "Game saved!"
        exit
      end
    end
  end
  
  def saved_games
    puts "\n", "Saved games: "
    Dir["./saved_games/*"].map { |file| file.split('/')[-1].split('.')[0] }
  end

  def load_game
    unless Dir.exist?('saved_games')
      puts 'No saved games found. Starting new game...'
      sleep(1)
      start_game
    end
    games = saved_games
    puts games
    deserialize(load_file(games))
  end

  def load_file(games)
    loop do
      puts "\n", "Enter the saved game you would like to load: "
      load_file = gets.chomp
      return load_file if games.include?(load_file)

      puts 'The game you requested does not exist.'
    end
  end

  def deserialize(load_file)
    # yaml = YAML.load("./saved_games/#{load_file}.yml")
    yaml = 
      File.open("./saved_games/#{load_file}.yml") do |f| 
        YAML.load(f)
      end
    puts "Game loaded."
    puts "\n", "So far, you've tried: #{yaml.instance_variable_get("@guesses").join(', ')}"
    yaml.start_game
  end

end

game = Hangman.new
game.game_menu
