class HumanPlayer
    def initialize(guess_progress = nil)
    @guess_progress = guess_progress
   end

    def submit_guess(guess_progress)
        print "Which letter? "
        gets.chomp
    end

    def submit_target_word
        print "Enter your word: "
        gets.chomp
    end

end
