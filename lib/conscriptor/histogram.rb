module Conscriptor
  module Histogram
    # Takes an array of values, groups them by identity and counts them, then produces a string output that
    # can be printed.
    #
    # 928  Foo
    # 55   Bar
    # 5    Baz
    def histogram(things, indent: '')
      occurences = {}
      things.each do |thing|
        occurences[thing] = (occurences[thing] || 0) + 1
      end
      lines = occurences
              .sort_by { |a, b| [b, a.to_s] }
              .reverse
              .map { |thing, count| "#{count}\t #{thing}" }

      "#{indent}#{lines.join("\n#{indent}")}"
    end
  end
end
