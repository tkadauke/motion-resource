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

      def has_many(name, options = {})
        default_options = {
          :params => lambda { |o| Hash.new },
          :class_name => name.to_s.classify
        }
        options = default_options.merge(options)
        
        backwards_association = self.name.underscore
        
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}") || []
          else
            if cached = instance_variable_get("@#{name}")
              cached_response = instance_variable_get("@#{name}_response")
              MotionResource::Base.request_block_call(block, cached, cached_response)
              return
            end

            klass = options[:class_name].constantize
            
            klass.find_all(options[:params].call(self)) do |results, response|
              if results && results.first && results.first.respond_to?("#{backwards_association}=")
                results.each do |result|
                  result.send("#{backwards_association}=", self)
                end
              end
              instance_variable_set("@#{name}", results)
              instance_variable_set("@#{name}_response", response)
              MotionResource::Base.request_block_call(block, results, response)
            end
          end
        end
        
        define_method "#{name}=" do |array|
          klass = options[:class_name].constantize
          
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

      def belongs_to(name, options = {})
        default_options = {
          :params => lambda { |o| Hash.new },
          :class_name => name.to_s.classify
        }
        options = default_options.merge(options)
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}")
          else
            if cached = instance_variable_get("@#{name}")
              cached_response = instance_variable_get("@#{name}_response")
              MotionResource::Base.request_block_call(block, cached, cached_response)
              return
            end
            klass = Object.const_get(options[:class_name])
            klass.find(self.send("#{name}_id"), options[:params].call(self)) do |result, response|
              instance_variable_set("@#{name}", result)
              instance_variable_set("@#{name}_response", response)
              MotionResource::Base.request_block_call(block, result, response)
            end
          end
        end
        
        define_method "#{name}=" do |value|
          value = Object.const_get(options[:class_name]).instantiate(value) if value.is_a?(Hash)
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
