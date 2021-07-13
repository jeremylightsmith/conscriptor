module Conscriptor
  module Say
    def say(what)
      `say #{what}`
    rescue StandardError
      # ignore
    end
  end
end
