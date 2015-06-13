load 'Trie.rb'

class TrieLevel

  attr_reader :level, :tries
  attr_writer :leve, :trees

  def initialize(trie = Trie.new)
    @level = 0
    @tries = [trie]
  end

  def children(k)
    k.times do |x|
      tries.map do |trie|
        trie.subtrees.to_a.map {|letter_subtree_pair| letter_subtree_pair[1]}.flatten
      end
    end
  end

  def refine(k)
    tries = children(k).select do |subtree|
      yield(subtree)
    end
    level += k
  end

  def exclude(k)
    tries = tries.select do |trie|
      yield(trie.parent)
    end
  end

  def restrict(k)
    if k < 0
      exclude(k * -1) do |trie|
        yield(trie)
      end
    else
      refine(k) do |trie|
        yield(trie)
      end
    end
  end
  

end
