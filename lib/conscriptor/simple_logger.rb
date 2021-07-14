require 'logger'

def simple_logger
  logger = Logger.new($stdout)
  logger.formatter = proc do |_severity, _datetime, _progname, msg|
    "#{msg}\n"
  end
  logger
end
