module MotionResource
  class Base
    class_attribute :logger
    self.logger = MotionSupport::StdoutLogger.new
  end
end
