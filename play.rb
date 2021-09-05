require 'yaml'

class Ogre
  attr_accessor :strength, :speed, :smell
  def initialize(strength, speed, smell)
    @strength = strength
    @speed = speed
    @smell = smell
  end
end

class Dragon
  attr_accessor :strength, :speed, :color
  def initialize(strength, speed, color)
    @strength = strength
    @speed = speed
    @color = color
  end
end

class Fairy
  attr_accessor :strength, :speed, :intelligence
  def initialize(intelligence)
    @strength = 1
    @speed = 42
    @intelligence = intelligence
  end
end

def save_game(characters)
	yaml = YAML::dump(characters)
  game_file = GameFile.new("/my_game/saved.yaml")
  game_file.write(yaml)
end

def load_game
  game_file = GameFile.new("/my_game/saved.yaml")
  yaml = game_file.read
  YAML::load(yaml)
end

def save_game(characters)
  puts 'Enter name of your save file: '
  filename = gets.chomp

  Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
  # File.open("./saved_games/#{filename}.yml", 'w') do |file| 
  #   YAML.dump(self, file)
  # end
  yaml = YAML::dump(characters)
  game_file = GameFile.new('./saved_games/#{filename}.yml')
  game_file.write(yaml)
  puts "Game saved!"
  exit
end

save_game(characters)
