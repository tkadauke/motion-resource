module MotionResource
  class NullLogger
    def log(string)
    end
  end

  class StdoutLogger
    def log(string)
      puts string
    end
  end

  class Base
    class_inheritable_accessor :logger
    self.logger = NullLogger.new
  end
end
