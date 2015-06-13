load 'ComputerPlayer.rb'
load 'HumanPlayer.rb'

class Game

   attr_reader :max_guesses, :number_of_guesses, :guess_progress,
   :guessing_player, :checking_player, :target_word, :prev_guess_progress
   attr_writer :max_guesses, :number_of_guesses, :guess_progress,
   :guessing_player, :checking_player, :target_word, :prev_guess_progress


    def initialize
        @max_guesses = 10
        @number_of_guesses = 0
        @checking_player = nil
        @guessing_player = nil
        @guess_progress = nil
        @target_word = nil
        initialize_game_type
        play
    end

    def initialize_game_type
        print "Watch, CPU or 2 Player?(w/c/2) "
        type = gets.chomp.downcase
        if type == "w"
            @checking_player = ComputerPlayer.new
            initialize_target_word
            initialize_guess_progress
            @guessing_player = ComputerPlayer.new(guess_progress)
        elsif type == "c"
           initialize_cpu_game
        else
            @checking_player = HumanPlayer.new
            initialize_target_word
            initialize_guess_progress
            @guessing_player = HumanPlayer.new(guess_progress)
        end
    end

    def initialize_cpu_game
        print "Do you want to be the guesser?(y/n) "
        if gets.chomp.downcase == 'y'
            @checking_player = ComputerPlayer.new
            initialize_target_word
            initialize_guess_progress
            @guessing_player = HumanPlayer.new(guess_progress)
        else
            @checking_player = HumanPlayer.new
            initialize_target_word
            initialize_guess_progress
            @guessing_player = ComputerPlayer.new(guess_progress)
        end
    end

    def play
        display_game
        until over? do
            interpret_guess(guessing_player.submit_guess(guess_progress))
            display_game
        end
        show_game_result
    end

    def over?
        @guess_progress == target_word || number_of_guesses == max_guesses
    end

    def initialize_guess_progress
       @guess_progress = "_" * target_word.length
    end

    def initialize_target_word
        @target_word = checking_player.submit_target_word
    end

    def interpret_guess(guess)
        target_word.chars.each_with_index do |char, idx|
            @guess_progress[idx] = char if char == guess
        end
    end

    def display_game
        puts "secret_word: " + guess_progress
    end

    def show_game_result
        puts guess_progress == target_word ? "You guessed it!" : "Too many guesses"
    end


end
