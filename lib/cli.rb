require_relative 'diff'

module TextaRator
  class CLI
    def self.main(*args)
      origin = File.readlines(args[0][0]).map(&:strip)
      edited = File.readlines(args[0][1]).map(&:strip)
      Comparator.new(origin, edited).print
    end
  end
end