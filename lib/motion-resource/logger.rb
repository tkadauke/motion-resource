module MotionResource
  class Base
    class_inheritable_accessor :logger
    self.logger = MotionSupport::NullLogger.new
  end
end
