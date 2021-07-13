# this will include hierarchical context ONLY when you log. so you can add parents and grandparents of a lesson,
# and only when you call "info" will those print out.
#
# Allows you to track layers of context, e.g. multiple levels of iteration schools -> conference_reports -> widgets.
#
# Historical context: there's a bunch of code in lesson importing that was managing hierarchical logging before this
# code was born, and we could probably use this here.
module Conscriptor
  class HierarchicalContextLogger
    attr_writer :context

    def initialize
      @context = []
      @printed_context = []
    end

    # write a message with the context printed as well
    def info(message)
      @context.length.times do |level|
        puts_at_level @context[level], level if @context[0..level] != @printed_context[0..level]
      end
      @printed_context = @context.dup
      puts_at_level message, @context.length
    end

    def with_context(thing)
      push_context(thing)
      yield
    ensure
      pop_context
    end

    # ideally, use #with_context instead
    # adds a level of context, e.g. 'school' or 'user'
    def push_context(thing)
      @context.push(thing)
    end

    # ideally, use #with_context instead
    def pop_context
      @context.pop
    end

    def pop_context_to(level:)
      @context.pop while @context.length > level
    end

    private

    def puts_at_level(message, level)
      puts "#{'   ' * level}#{message}"
    end
  end
end
