class Tag < MotionResource::Base
  attr_accessor :name
  
  belongs_to :color
end
