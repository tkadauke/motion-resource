module MotionResource
  class Base
    include MotionSupport::DescendantsTracker
    
    class_attribute :primary_key
    self.primary_key = :id
    
    attr_accessor :id
    
    def initialize(params = {})
      @new_record = true
      update_attributes(params)
    end
    
    def new_record?
      @new_record
    end
    
    class << self
      def instantiate(json)
        json = json.symbolize_keys
        raise ArgumentError, "No :#{primary_key} parameter given for #{self.name}.instantiate" unless json[primary_key]
        
        klass = if json[:type]
          begin
            Object.const_get(json[:type].to_s)
          rescue NameError
            self
          end
        else
          self
        end
        
        if result = klass.recall(json[primary_key])
          result.update_attributes(json)
        else
          result = klass.new(json)
          klass.remember(result.send(result.primary_key), result)
        end
        result.send(:instance_variable_set, "@new_record", false)
        result
      end
      
      def identity_map
        @identity_map ||= {}
      end
      
      def remember(id, value)
        identity_map[id] = value
      end
      
      def recall(id)
        identity_map[id]
      end
    end
  end
end
