require 'yaml'

#def chooses a random word
def random_word(alphabet_num, alphabet_num_arr)
  random_number = rand(alphabet_num)  #secret word
  secret_word = alphabet_num_arr[random_number]
  return secret_word
end

# 2 funktion, die länge vom wort usw ermittelt

def hangman_length(guess_word)
  word_length = guess_word.length
  return word_length-1
end


def print_word(length,word)
  puts "You already guessed: " + $already_guessed.join(", ")
  for i in 0..length
    print $arr[i]
    print " "
  end
  #test if game is over
  game_over(length,word)
  game(length,word)
end


def game_over(length,word)
  if $chances == 0
    puts "You lost this game! The word was #{word}\nDo you wanna play another one? Y/n"
    restart = gets.chomp
    game_restart(restart)
  else
    win = true
    $arr.each do |char|
      if char == "_"
        win = false
      end
    end
    if win
      newgame
    end
  end
end

def newgame
  puts " "
  puts "You won this game! Do you wanna play another one? Y/n"
  restart = gets.chomp
  game_restart(restart)
end

def game_restart(user_input)
  if user_input.downcase == "y" || user_input == ""
    main()
  else
    puts "game canceled"
    exit
  end
end

#3 funktion die die länge vom Wort hat und an die weitergegeben wird welcher buchstabe ausgewählt wurde und die dann das wort printet mit verändertem buchsteben

def right_guess(length,word)
  puts "That letter is in the word"
  
  print_word(length,word)
end

def wrong_guess(length,word)
  puts "That letter is not in the word"
  $chances -= 1
  puts "you have #{$chances} guesses left"
  result = game_over(length,word)
  puts result
  
  print_word(length,word)
end


#4 funktion die das spiel startet und den user nach input fragt --> 3 
def game(length,word)
  puts ""
  puts ""
  puts "type save to save your game or guess a character"
  user_guess = symbol_test(length,word)
  any_correct = false
  for i in 0..length
    if user_guess.downcase == word[i].downcase
      $arr[i] = word[i]
      any_correct = true
    end
  end
  if any_correct
    return right_guess(length,word)
  else
    return wrong_guess(length,word)
  end
end


def symbol_test(length,word)
  puts
  user_guess = gets.chomp
  if user_guess.downcase == "save"
    save(word)    
    exit
  elsif user_guess.length > 1
    puts "please type 1 symbol only"
    return symbol_test(length,word)
  end

  $already_guessed.each do |character|
    if user_guess.downcase == character.downcase
      puts "please choose another symbol"
      return symbol_test(length,word)
    end
  end
  
  $already_guessed << user_guess
  return user_guess
end

#5 funktion die von 3 aufgerufen wird und die überprüft ob alles im Array richtig ist 

def default_values
  $chances = 10
  $already_guessed = []
  lines = File.readlines "Words.txt"
  $possible_words_arr = []
  $possible_words_count = 0
  $generate_word = true

  lines.each do |line|
    if line.length > 5 && line.length < 12
      $possible_words_arr[$possible_words_count] = line
      $possible_words_count  = $possible_words_count + 1 
    end
  end

  $guess_word = random_word($possible_words_count, $possible_words_arr)
  word_length = hangman_length($guess_word)
  $arr = Array.new(word_length, "_")
end

def save(word) 
  save_data = { word: word,
                already_guessed: $already_guessed,
                chances: $chances,
                arr: $arr }
  save_file = File.open("hangman.yml", "w") { |file| file.write(save_data.to_yaml)}
end

def read_from_save()
    save_data = YAML.load(File.read("hangman.yml"))
    $guess_word = save_data[:word]
    $chances = save_data[:chances]
    $already_guessed = save_data[:already_guessed]
    $arr = save_data[:arr]
end

#6 calls all function in order
def main()

  data_was_read = false

  if File.exist? "hangman.yml"
    puts "do you wanna open a saved file? Y/n"
    answer = gets.chomp
    if answer.downcase == "y" || answer == ""
      read_from_save
      data_was_read = true
      print_word(hangman_length($guess_word), $guess_word)
    end
  end

  if !data_was_read
    default_values
  end

  $arr.each do |char|
    print char
    print " "
  end
  game = game(hangman_length($guess_word), $guess_word)
end

main()