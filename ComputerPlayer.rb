load 'TrieLevel.rb'

class ComputerPlayer

  attr_reader :guess_locations_hash, :guesses, :dictionary, :prev_guess_progress, :guess_locations_hash, :dict_locations_hash, :trie_level
  attr_writer :guess_locations_hash, :guesses, :dictionary, :prev_guess_progress, :guess_locations_hash, :dict_locations_hash, :trie_level

  def initialize(guess_progress = nil)

    @guesses = []
    @prev_guess_progress = guess_progress
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)
    @trie_level = nil
    if guess_progress
      select_by_size(guess_progress.length)
      initialize_trie_level
    end
  end

  def select_by_size(n)
    dictionary.select! {|word| word.length == n}
  end

  def initialize_trie_level
    dict_trie = Trie.new
    dictionary.each {|word| dict_trie.insert(word)}
    @trie_level = TrieLevel.new(dict_trie)
  end



  def submit_target_word
    File.readlines('dictionary.txt').sample.chomp
  end

  def submit_guess(guess_progress)
    new_locations = diff(guess_progress)
    @prev_guess_progress = guess_progress
    improve_level(new_locations)
    guess = infer_guess
    guesses.push(guess)
    guess
  end

  def improve_level(new_locations)
    new_locations.each do |location|
      trie_level.restrict(location - trie_level.level) do |trie|
        trie.word[-1] == letter
      end
    end
  end

  def infer_guess
    aggregate_frequency_hash = trie_level.tries.reduce({}) do |so_far, trie|
      so_far.combine(trie.root.frequency_hash)
    end

    most_frequent_letter(aggregate_frequency_hash)
  end

  def most_frequent_letter(aggregate_frequency_hash)
    guess = nil
    greatest_frequency = 0
    aggregate_frequency_hash.each do |letter, freq|
      guess = letter if freq > greatest_frequency && !@guesses.include?(letter)
    end
    guess
  end

  def diff(current_guess_progress)
    current_guess_progress.chars.map.with_index do |char, i|
      char == @prev_guess_progress[i] ? nil : i
    end.compact
  end

end
