module MotionResource
  module SpecHelpers
    def self.extended(base)
      base.after do
        forget_instances_of(MotionResource::Base)
      end
    end
    
    def forget_instances_of(klass)
      klass.identity_map.clear
      klass.subclasses.each do |subklass|
        forget_instances_of(subklass)
      end
    end
  end
end
