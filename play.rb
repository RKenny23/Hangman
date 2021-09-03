@letters = ('a'..'z').to_a

guess = "7"

if !@letters.include?(guess)
  puts "included"
else
  puts "not included"
end
