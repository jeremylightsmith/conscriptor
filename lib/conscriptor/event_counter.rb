require_relative './histogram'
require_relative './simple_logger'

module Conscriptor
  class EventCounter
    include Histogram

    def initialize(logger=simple_logger)
      @logger = logger
      clear
    end

    def record(event)
      record_many(event, 1)
    end

    def record_and_print(symbol, event)
      record(event)
      print symbol
      @key[event] = symbol
    end

    def record_many(event, how_many)
      @counts[event] ||= 0
      @counts[event] += how_many
    end

    def [](event)
      @counts[event]
    end

    def record_error(event, error)
      (@errors[event] ||= []) << error
    end

    def clear(*keys)
      if keys.empty?
        @counts = {}
        @errors = {}
      else
        keys.each do |key|
          @counts.delete(key)
          @errors.delete(key)
        end
      end
      @key = {}
    end

    def empty?
      @counts.empty?
    end

    def errors?
      !@errors.empty?
    end

    def to_s
      @counts.map { |k, v| "#{k} = #{v}" }.sort.join(', ')
    end

    def dump
      @logger.info("\n#{@counts.sort_by { |_k, v| -v }.map { |k, v| "#{k} = #{v}" }.join("\n")}")

      unless @errors.empty?
        require 'colorize'

        @errors.each do |event, errors|
          @logger.info "Error #{event} (#{errors.count}):\n#{histogram(errors)}".red
        end
      end

      print_key
    end

    def print_key
      return if @key.empty?

      puts "\nKey"
      @key.each do |event, symbol|
        puts "    #{symbol} = #{event} (#{@counts[event]})"
      end
    end

    def to_h
      @counts
    end
  end
end
