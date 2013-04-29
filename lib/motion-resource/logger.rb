module MotionResource
  class Base
    class_attribute :logger
    self.logger = MotionSupport::NullLogger.new
  end
end
