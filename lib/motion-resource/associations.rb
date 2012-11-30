module MotionResource
  class Base
    class << self
      def has_one(name)
        define_method name do
          instance_variable_get("@#{name}")
        end
        
        define_method "#{name}=" do |value|
          klass = Object.const_get(name.to_s.classify)
          value = klass.instantiate(value) if value.is_a?(Hash)
          instance_variable_set("@#{name}", value)
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end

      def has_many(name, params = lambda { |o| Hash.new })
        backwards_association = self.name.underscore
        
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}") || []
          else
            if cached = instance_variable_get("@#{name}")
              block.call(cached)
              return
            end
            
            Object.const_get(name.to_s.classify).find_all(params.call(self)) do |results|
              if results && results.first && results.first.respond_to?("#{backwards_association}=")
                results.each do |result|
                  result.send("#{backwards_association}=", self)
                end
              end
              instance_variable_set("@#{name}", results)
              block.call(results)
            end
          end
        end
        
        define_method "#{name}=" do |array|
          klass = Object.const_get(name.to_s.classify)
          instance_variable_set("@#{name}", [])
          
          array.each do |value|
            value = klass.instantiate(value) if value.is_a?(Hash)
            instance_variable_get("@#{name}") << value
          end
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end

      def belongs_to(name, params = lambda { |o| Hash.new })
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}")
          else
            if cached = instance_variable_get("@#{name}")
              block.call(cached)
              return
            end
          
            Object.const_get(name.to_s.classify).find(self.send("#{name}_id"), params.call(self)) do |result|
              instance_variable_set("@#{name}", result)
              block.call(result)
            end
          end
        end
        
        define_method "#{name}=" do |value|
          klass = Object.const_get(name.to_s.classify)
          value = klass.instantiate(value) if value.is_a?(Hash)
          instance_variable_set("@#{name}", value)
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end
    end

    class << self
      def scope(name, options = {})
        custom_urls "#{name}_url" => options[:url] if options[:url]
        
        metaclass.send(:define_method, name) do |&block|
          fetch_collection(send("#{name}_url"), &block)
        end
      end
    end
  end
end
