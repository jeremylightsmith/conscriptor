require_relative './simple_logger'

module Conscriptor
  class ProgressReporter
    attr_reader :count

    def initialize(total:, name: nil, report_every: 1, logger: nil)
      @name = name
      @total = total
      @report_every = report_every || 1
      @logger = logger || simple_logger
      @count = 0
      @start_time = Time.now
    end

    def inc(name: @name, by: 1)
      @count += by

      if @count % @report_every == 0 # rubocop:disable Style/GuardClause
        percent_complete = 100 * @count / @total
        time_spent = Time.now - @start_time
        time_left = @total * time_spent / @count - time_spent

        @logger.info "#{name} #{@count}/#{@total} (#{percent_complete}%)" \
                     " #{(time_spent / 60).round(1)}m spent," \
                     " #{(time_left / 60).round(1)}m to go-ish"
      end
    end

    def done?
      @count >= @total
    end
  end
end
