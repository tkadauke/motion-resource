module MotionResource
  class Base
    include MotionSupport::Callbacks

    define_callbacks :create, :save, :update, :destroy

    [:create, :save, :update, :destroy].each do |callback|
      define_singleton_method "before_#{callback}" do |*filters, &blk|
        set_callback(callback, :before, *filters, &blk)
      end

      define_singleton_method "after_#{callback}" do |*filters, &blk|
        set_callback(callback, :after, *filters, &blk)
      end
    end
  end
end
