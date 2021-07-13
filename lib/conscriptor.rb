require_relative 'conscriptor/event_counter'
require_relative 'conscriptor/hierarchical_context_logger'
require_relative 'conscriptor/histogram'
require_relative 'conscriptor/progress_reporter'
require_relative 'conscriptor/say'

module Conscriptor
  autoload :VERSION, 'conscriptor/version'
  include Conscriptor::Say
  include Conscriptor::Histogram

  def clog
    @clog ||= Conscriptor::HierarchicalContextLogger.new
  end

  def counts
    $counts ||= Conscriptor::EventCounter.new # rubocop:disable Style/GlobalVars
  end

  def safe_transaction
    ActiveRecord::Base.transaction do
      begin
        yield
        say "job's done"
      rescue StandardError
        say 'nope'
        raise
      end

      counts.dump
      commit_or_rollback
    end
  end

  # save an active record, even if it has errors
  def save_even_with_errors(obj)
    return if obj.save

    counts.record_and_print('!'.yellow, "Error saving: #{obj.errors.full_messages.join(',')}")
    obj.save validate: false
  end

  def app_backtrace(exception)
    bc = ActiveSupport::BacktraceCleaner.new
    bc.clean(exception.backtrace)
  end

  def print_error
    puts $ERROR_INFO.message.red
    puts app_backtrace($ERROR_INFO).map { |b| "    #{b}" }.join("\n").red
  end

  def catch_exceptions(message='')
    yield
  rescue StandardError
    print message.red
    print_backtrace
  end

  def commit_or_rollback
    puts "\nCommit? (y/n)"

    if $stdin.gets.chomp == 'y'
      puts 'Committing.'
    else
      puts 'Rolling Back.'
      raise ActiveRecord::Rollback
    end
  end

  def time(name)
    start = Time.now
    retval = nil
    begin
      retval = yield
    ensure
      ((@times ||= {})[name] ||= []) << Time.now - start
    end
    retval
  end

  def print_times
    puts 'Printing Times'.bold
    @times.each do |name, times|
      puts "  #{name} (#{times.count} times) : #{times.sum / times.count}s (avg)"
    end
  end

  # usage:
  # start_timer total: Lesson.count, report_every: 100
  def start_timer(name: nil, total: nil, report_every: nil, log: nil)
    @progress = Conscriptor::ProgressReporter.new(name: name, total: total, report_every: report_every, log: log)
  end

  def inc_timer(by: 1)
    @progress.inc(by: by)
  end

  # lines in a file
  def num_lines(file)
    `wc -l < #{file}`.to_i
  end
end
